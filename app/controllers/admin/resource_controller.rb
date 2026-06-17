module Admin
  # Generic CRUD for admin-managed models. Subclasses declare the model and the
  # permitted attributes; views are shared generic templates that reflect on
  # the model's columns. Override per resource as the product matures.
  class ResourceController < BaseController
    before_action :set_record, only: %i[show edit update destroy]

    def index
      @records = resource_scope
      render "admin/resources/index"
    end

    def show
      render "admin/resources/show"
    end

    def new
      @record = model_class.new
      render "admin/resources/new"
    end

    def edit
      render "admin/resources/edit"
    end

    def create
      @record = model_class.new(resource_params)
      if @record.save
        redirect_to [ :admin, redirect_target ], notice: t("actions.create")
      else
        render "admin/resources/new", status: :unprocessable_entity
      end
    end

    def update
      if @record.update(resource_params)
        redirect_to [ :admin, redirect_target ], notice: t("actions.save")
      else
        render "admin/resources/edit", status: :unprocessable_entity
      end
    end

    def destroy
      @record.destroy
      redirect_to polymorphic_path([ :admin, model_class ]), notice: t("actions.delete")
    end

    helper_method :model_class, :resource_columns, :form_columns

    private

    def model_class
      controller_name.classify.constantize
    end

    def resource_scope
      model_class.all.order(created_at: :desc)
    end

    def redirect_target
      model_class.column_names.include?("slug") ? @record : @record
    end

    def set_record
      finder = model_class.respond_to?(:friendly) ? model_class.friendly : model_class
      @record = finder.find(params[:id])
    end

    # Columns shown in index tables (skip noisy/internal fields).
    def resource_columns
      model_class.column_names - %w[id created_at updated_at slug encrypted_password reset_password_token reset_password_sent_at remember_created_at raw data sector_times specs socials benefits]
    end

    # Columns rendered in the generic form.
    def form_columns
      resource_columns - %w[]
    end

    # Subclasses must implement this for safe mass-assignment.
    def resource_params
      params.require(model_class.model_name.param_key).permit(*permitted_attributes)
    end

    def permitted_attributes
      resource_columns
    end
  end
end
