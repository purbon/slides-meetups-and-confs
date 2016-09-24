module Helpers

  def self.included(base)
    base.class_eval do
      base.extend Methods
      include Methods
    end
  end

  module Methods

    def paginate_params(params = {})
      params ||= {}
      page = (params[:page] || params['page'] || 1).to_i
      per_page = (params[:per_page] || params['per_page'] || 0).to_i

      first = (page-1) * per_page
      last  = first + per_page -1
      [first, last]
    end

    #
    #  Takes an array and a hash and slices the hash to the section
    #  requested by params[:page] and params[:per_page]
    #
    def paginate(collection, params = {})
      first, last = paginate_params(params)
      collection[first..last]
    end
  end
end
