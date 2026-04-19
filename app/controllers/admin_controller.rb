class AdminController < ApplicationController
  CONFIRM_PHRASE = "DELETE ALL DATA".freeze

  def show
    @table_counts = model_counts
  end

  def confirm_destroy
    @table_counts = model_counts
  end

  def destroy_all
    if params[:confirmation].to_s.strip != CONFIRM_PHRASE
      flash[:alert] = "Confirmation phrase did not match. No data was deleted."
      redirect_to confirm_destroy_admin_path and return
    end

    deleted = 0
    ActiveRecord::Base.transaction do
      deletion_order(discover_models).each do |model|
        deleted += model.delete_all
      end
    end

    flash[:notice] = "Deleted #{deleted} record#{'s' unless deleted == 1} across #{discover_models.count} table#{'s' unless discover_models.count == 1}."
    redirect_to admin_path
  end

  private

  def model_counts
    discover_models.map { |m| [ m, m.count ] }.sort_by { |m, _| m.name }
  end

  def discover_models
    Rails.application.eager_load!
    ApplicationRecord.descendants.select do |m|
      !m.abstract_class? && m.table_exists?
    end
  end

  def deletion_order(models)
    remaining = models.dup
    ordered = []
    until remaining.empty?
      leaf = remaining.find do |m|
        (remaining - [ m ]).none? do |other|
          other.reflect_on_all_associations(:belongs_to).any? do |r|
            !r.polymorphic? && safe_klass(r) == m
          end
        end
      end
      leaf ||= remaining.first
      ordered << leaf
      remaining.delete(leaf)
    end
    ordered
  end

  def safe_klass(reflection)
    reflection.klass
  rescue NameError
    nil
  end
end
