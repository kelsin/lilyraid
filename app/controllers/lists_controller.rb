class ListsController < ApplicationController
    before_filter(:load_list, :only => [:show])

    def index
        @list = List.get_list(Preference.get_setting('guild'))
    end

    private

    def load_list
        @list = List.find(params[:id])
    end
end
