module SubjectsUiHelper
  def visit_images images=nil
    images ||= Image.all
    visit "#{ui_path}/#/images/"
    within("cap-image-selector") do
      expect(page).to have_css(".image-list")
      expect(page).to have_css(".image-list li",:count=>images.count,:wait=>5)
    end
  end

  def image_caption image
    image.caption || "(no caption #{image.id})" 
  end

  def get_linkables image
    things=ThingPolicy::Scope.new(current_user, Thing.not_linked(image)).user_roles(true,false)
    things=ThingPolicy.merge(things)
  end

  def image_editor_loaded! image, expected_linkables=nil
    within("cap-image-editor .image-form") do
      expect(page).to have_css("span.image_id",:text=>image.id,:visible=>false)
      expect(page).to have_css(".image-controls")
      expect(page).to have_css("ul.image-things li span.thing_id",
                              :visible=>false,
                              :count=>ThingImage.where(:image=>image).count,
                              :wait=>5)
      expect(page).to have_css("div.image-existing img",:count=>1,:wait=>5)
    end
    expected_linkables ||= get_linkables(image).size
    if expected_linkables && logged_in?
      expect(page).to have_css(".link-things select option", :count=>expected_linkables)
    end
  end

  def visit_image image
    unless page.has_css?("cap-image-editor .image-form span.image_id", 
                          :text=>image.id,:visible=>false)
      visit "#{ui_path}/#/images/#{image.id}"
    end
    within("cap-image-editor .image-form") do
      expect(page).to have_css("span.image_id",
                               :text=>image.id,:visible=>false,:wait=>5)
      expect(page).to have_css(".image-controls")
      expect(page).to have_css("div.image-existing img",:count=>1,:wait=>5)
    end
  end

  def displayed_caption(image)
    image.caption ? image.caption : "(no caption #{image.id})" 
  end

  def visit_thing thing
    unless page.has_css?("cap-thing-editor .thing-form span.thing_id", 
                          :text=>thing.id,:visible=>false)
      visit "#{ui_path}/#/things/#{thing.id}"
    end
    within("cap-thing-editor .thing-form") do
      expect(page).to have_css("span.thing_id",
                               :text=>thing.id,
                               :visible=>false,
                               :wait=>5)
    end
  end

  def thing_editor_loaded! thing
    expect(page).to have_css("cap-thing-editor")
    within("cap-thing-editor .thing-form") do
      expect(page).to have_css("span.thing_id",:text=>thing.id,
                                               :visible=>false)
      expect(page).to have_css("cap-image-viewer .image-area img",
                              :visible=>false,
                              :count=>ThingImage.where(:thing=>thing).count,
                              :wait=>5)
      if (page.has_css?("ul.thing-images"))
        expect(page).to have_css("ul.thing-images li span.image_id",
                                :visible=>false,
                                :count=>ThingImage.where(:thing=>thing).count,
                                :wait=>5)
      end
    end
  end

  def visit_things things
    visit "#{ui_path}/#/things/"
    within("cap-thing-selector", :wait=>5) do
      if logged_in? 
        expect(page).to have_css(".thing-list")
        expect(page).to have_css(".thing-list li",:count=>things.count, :wait=>5)
      end
    end
  end
end
