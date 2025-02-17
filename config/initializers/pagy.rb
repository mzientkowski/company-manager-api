require "pagy/extras/jsonapi"
require "pagy/extras/metadata"

Pagy::DEFAULT[:limit] = 20
Pagy::DEFAULT[:page_param] = :number
Pagy::DEFAULT[:limit_param] = :limit

Pagy::DEFAULT[:jsonapi] = true
Pagy::DEFAULT[:metadata] = %i[count pages limit page next prev]
