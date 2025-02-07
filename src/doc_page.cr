require "./doc_set"

require "./new_page"

class DocPage < Adw::Bin
  @[GObject::Property]
  property title : String = "Choose a DocSet"
  property docset : DocSet

  @web_view : WebKit::WebView?

  def initialize(@docset, uri : String? = nil)
    super(hexpand: true, vexpand: true)
    if uri
      load_uri(uri)
    else
      self.child = NewPage.new
    end
  end

  def uri : String?
    @web_view.try(&.uri)
  end

  def focus_page
    @web_view.try(&.grab_focus)
  end

  def go_back : Nil
    @web_view.try(&.go_back)
  end

  def can_go_back? : Bool
    @web_view.try(&.can_go_back) || false
  end

  def go_forward : Nil
    @web_view.try(&.go_forward)
  end

  def can_go_forward? : Bool
    @web_view.try(&.can_go_forward) || false
  end

  def load_uri(uri : String)
    web_view = @web_view
    if web_view.nil?
      @web_view = web_view = WebKit::WebView.new
      web_view.bind_property("title", self, "title", :default)
      self.child = web_view
    end

    web_view.load_uri(uri)
  end
end
