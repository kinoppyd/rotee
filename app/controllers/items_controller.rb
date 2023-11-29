class ItemsController < ApplicationController
  before_action :set_list
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = @list.items.build
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.list_id = params["list_id"]
    @item.position = @item.list.items.size

    respond_to do |format|
      if @item.save
        format.html { redirect_to list_url(@list), notice: "Item was successfully created." }
        format.turbo_stream { render :create }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to list_item_url(@item.list, @item), notice: "Item was successfully updated." }
        format.turbo_stream { render :update }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy!
    reorder_lest_items(@item.position)

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.turbo_stream { render :destroy }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :position, :list_id)
    end

  def set_list
    @list = List.find(params[:list_id])
  end

  def reorder_lest_items(position)
    @item.list.items.where("position > ?", position).each do |i|
      i.update(position: i.position - 1)
    end
  end
end
