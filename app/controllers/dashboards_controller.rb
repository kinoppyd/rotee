class DashboardsController < ApplicationController
  before_action :set_dashboard, only: %i[ show edit update destroy ]

  # GET /dashboards/1 or /dashboards/1.json
  def show
    @dashboard.lists.map { make_sure_cycle_trigger(_1) }
  end

  # GET /dashboards/new
  def new
    @dashboard = Dashboard.new
  end

  # GET /dashboards/1/edit
  def edit
  end

  # POST /dashboards or /dashboards.json
  def create
    @dashboard = Dashboard.new(dashboard_params)

    respond_to do |format|
      if @dashboard.save
        format.html { redirect_to dashboard_url(@dashboard), notice: "Dashboard was successfully created." }
        format.json { render :show, status: :created, location: @dashboard }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dashboards/1 or /dashboards/1.json
  def update
    respond_to do |format|
      if @dashboard.update(dashboard_params)
        format.html { redirect_to dashboard_url(@dashboard), notice: "Dashboard was successfully updated." }
        format.json { render :show, status: :ok, location: @dashboard }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @dashboard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dashboards/1 or /dashboards/1.json
  def destroy
    @dashboard.destroy!

    respond_to do |format|
      format.html { redirect_to dashboards_url, notice: "Dashboard was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dashboard
      @dashboard = Dashboard.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def dashboard_params
      params.require(:dashboard).permit(:title)
    end

    def make_sure_cycle_trigger(list)
      current = Time.current
      return if current < list.next_trigger_at

      threshold = list.daily? ? 24 * 60 * 60 : 24 * 60 * 60 * 7
      forward_pointer_count = ((current - list.next_trigger_at) / threshold).to_i % list.items.size
      next_pointer = list.pointer + forward_pointer_count
      list.pointer = list.items.size <= next_pointer ? next_pointer - list.items.size : next_pointer

      list.next_trigger_at = list.next_trigger_at + (list.daily? ? 24.hours : (7 * 24).hours) while list.next_trigger_at >= current
      list.save
    end
end
