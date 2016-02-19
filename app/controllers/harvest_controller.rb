class HarvestController < ApplicationController
  before_filter :require_admin

  def sync_clients
    Seeds::Harvest.seed!
    redirect_to clients_path
  end
end

