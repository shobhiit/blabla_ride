
class VehiclesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vehicle, only: [:show, :update, :destroy]
  # GET /vehicles
  def index
    @vehicles = current_user.vehicles.all
    render json: { code: 200, data: @vehicles }
  end
  

  def show_by_id
    @vehicle = Vehicle.find(params[:id])
    render json: @vehicle
  end

  # GET /vehicles/1
  def show
    render json: @vehicle
  end

  # POST /vehicles
  def create
    @vehicle = current_user.vehicles.new(vehicle_params)

    if @vehicle.save
      render json: { status: { code: 201 , data: @vehicle }}, status: :created
    else
      render json: { status: { code: 422 , error: @vehicle.errors}}, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vehicles/1
  def update
    vehicle = current_user.vehicles.find(params[:id])
    # vehicle = current_user.vehicles

    if vehicle.update(vehicle_params)
      render json: {
        status: { code: 200, message: 'Vehicle updated successfully' ,
        data: vehicle,
        }}, status: :ok
    else
      render json: {
        status: { message: 'Failed to update vehicle', errors: vehicle.errors.full_messages },
        status: :unprocessable_entity
      }
    end
  end

  # DELETE /vehicles/1
  def destroy
    @vehicle.destroy
    render json: { status: { code: 200, message: 'Vehicle was successfully destroyed' } },status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = current_user.vehicles.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def vehicle_params
      params.require(:vehicle).permit(:country, :vehicle_number, :vehicle_brand, :vehicle_name, :vehicle_type, :vehicle_color, :vehicle_model_year)
    end
end
