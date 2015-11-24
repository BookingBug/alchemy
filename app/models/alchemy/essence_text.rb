module Alchemy
  class EssenceText < ActiveRecord::Base

    acts_as_essence

    attr_accessible(
      :do_not_index,
      :body,
      :public,
      :link,
      :link_title,
      :link_class_name,
      :link_target
    )

    

  end
end
