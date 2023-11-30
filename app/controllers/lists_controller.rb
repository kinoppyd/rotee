class ListsController < ApplicationController
  before_action :set_list, only: %i[ show edit update destroy ]
  before_action :set_dashboard, only: %i[new create]
  before_action :make_sure_cycle_trigger, only: %i[show]

  # GET /lists or /lists.json
  def index
    @lists = List.all
  end

  # GET /lists/1 or /lists/1.json
  def show
  end

  # GET /lists/new
  def new
    @list = @dashboard.lists.build
  end

  # GET /lists/1/edit
  def edit
  end

  # POST /lists or /lists.json
  def create
    @list = List.new(list_params)
    @list.dashboard_id = params[:dashboard_id]

    respond_to do |format|
      if @list.save
        format.html { redirect_to list_url(@list), notice: "List was successfully created." }
        format.turbo_stream { render :create }
        format.json { render :show, status: :created, location: @list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lists/1 or /lists/1.json
  def update
    respond_to do |format|
      if @list.update(list_params)
        format.html { redirect_to list_url(@list), notice: "List was successfully updated." }
        format.json { render :show, status: :ok, location: @list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1 or /lists/1.json
  def destroy
    @list.destroy!

    respond_to do |format|
      format.html { redirect_to lists_url, notice: "List was successfully destroyed." }
      format.turbo_stream { render :destroy }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_list
      @list = List.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.require(:list).permit(:title, :body, :pointer, :cycle, :next_trigger_at)
    end

    def make_sure_cycle_trigger
      return if Time.current < @list.next_trigger_at

      @list.pointer = @list.items.size <= @list.pointer + 1 ? 0 : @list.pointer + 1
      @list.next_trigger_at = @list.next_trigger_at + (@list.daily? ? 24.hours : (7 * 24).hours)
      @list.save
    end

  def set_dashboard
    @dashboard = params[:dashboard_id] ? Dashboard.find(params[:dashboard_id]) : @list.dashboard.id
  end
end
