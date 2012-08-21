
# Setup

## Engine


Template engine can be set globally, at class level, then inside actions you simply call `render` and counterparts.

This way you can change your engine for an entire app with minimal impact, without refactoring a single action.

By default Espresso uses ERB template engine.

**Example:** - Set :Erubis for current controller

```ruby
class App < E
    # ...
    engine :Erubis
end
```

**Example:** - Set :Haml for an entire slice

```ruby
module App
    class News < E
        # ...
    end

    class Articles < E
        # ...
    end
end

app = App.mount do
    engine :Haml
end
app.run
```

If engine requires some arguments/options, simple pass them as consequent params.

Just like

```ruby
engine :SomeEngine, :some_arg, :some => :option
```

**Example:** - Set default encoding

```ruby
engine :Erubis, default_encoding: Encoding.default_external
```


**[ [contents &uarr;](https://github.com/slivu/espresso#tutorial) ]**


## Extension


Espresso will use the default extension of current engine.

To set a custom extension, use `engine_ext`.

**Example:**

```ruby
class App < E
    # ...

    engine :Erubis
    engine_ext :xhtml
end
```

**[ [contents &uarr;](https://github.com/slivu/espresso#tutorial) ]**


## Templates path


By default, Espresso will look for templates in "view/" folder, inside your app root.

If that's not your case, use `view_path` to inform Espresso about correct path.

**Example:**

```ruby
class App < E
    map '/cms'

    view_path 'base/view'

    def index
        # ...
        render # this will render base/view/cms/index.erb
    end

    def books__free
        # ...
        render # this will render base/view/cms/books/free.erb
    end
end
```

For cases when your templates are placed out of app root,
provide an absolute path to templates, i.e., a path starting with a slash.

**Example:**

```ruby
class News < E

    view_path File.expand_path '../../../shared-templates', __FILE__
    # ...
end
```

If app deployed on a non-Unix-like system, you should use `view_fullpath` instead.

**Example:**

```ruby
class News < E

    view_fullpath File.expand_path '../../../shared-templates', __FILE__
    # ...
end
```

**[ [contents &uarr;](https://github.com/slivu/espresso#tutorial) ]**

## Layouts path


By default, Espresso will look for layouts in same folder as templates, i.e., in "view/"

Use `layouts_path` to set a custom path to layouts.<br/>
The path should be relative to templates path.

**Example:** - Search layouts in "view/layouts/"

```ruby
class App < Ruby
    # ...
    layouts_path 'layouts/'
end
```


**[ [contents &uarr;](https://github.com/slivu/espresso#tutorial) ]**


## Layout


By default no layouts will be searched/rendered.

You can instruct Espresso to render a layout by using `layout`

**Example:** - All actions will use :master layout

```ruby
class App < Ruby
    # ...
    layout :master
end
```


**Example:** - Only :signin and :signup actions will use :member layout

```ruby
class App < Ruby
    # ...
    setup :signin, :signup do
        layout :member
    end
end
```

To make some action ignore layout rendering, use `layout false`

**Example:** - All actions, but :rss, will use layout

```ruby
class App < Ruby
    # ...
    layout :master
    setup :rss do
        layout false
    end
end
```

**[ [contents &uarr;](https://github.com/slivu/espresso#tutorial) ]**


# Render

## `render` and `render_partial`

To *render the template of current action*, simply call `render` without arguments.

```ruby
class App < E
  
  map 'news'
  view_path 'base/views'
  layout :master
  engine :Haml

  def some_action
      # ...
      render  # will render base/views/news/some_action.haml, using :master layout
  end

  def some__another_action
      # ...
      render_partial  # will render base/views/news/some__another_action.haml, without layout
  end

end
```

*=== Important ===* Template name should exactly match the name of current action, including REST verb, if any.

```ruby
def get_latest
  render # will try to render base/views/news/get_latest.haml
end

def post_latest
  render # will try to render base/views/news/post_latest.haml
end
```

Also, if current action called with a specific format, template name should contain it.

```ruby
class App < E
  
  map '/'
  format :xml, :html

  def post_latest
    render  # on /latest      it will render view/post_latest.erb
            # on /latest.xml  it will render view/post_latest.xml.erb
            # on /latest.html it will render view/post_latest.html.erb
  end
end
```


To *render a template by name*, pass it as first argument.

```ruby
render :some__another_action   # will render base/views/news/some__another_action.haml

render 'some_action.xml'       # will render base/views/news/some_action.xml.haml

render 'some-template'         # will render base/views/news/some-template.haml

render 'some-template.html'    # will render base/views/news/some-template.html.haml
```


To *render a template of inner controller*, pass controller as first argument and the template as second.

```ruby
class Articles < E
  
  view_path 'templates'
  engine :Slim
  # ...
end

render Articles, :most_popular         # will render templates/articles/most_popular.slim
render Articles, 'some-template.xml'   # will render templates/articles/some-template.xml.slim
```


*Scope* and *Locals* can be passed as consequent arguments, orderlessly.<br/>
The scope is defaulted to current one and locals to an empty Hash.


As *extension* will be used the explicitly defined extension(at class level)
or the default extension of used engine.

**Layout**

*   If current action rendered, layout of current action will be used, if any.
*   If custom action rendered, layout of given action will be used, if any.
*   If an arbitrary template rendered, layout of current action will be used, if any.

**Engine**

As engine will be used the effective engine for current context.<br/>
Meant engine defined for current or given action,
or engine defined for all actions,
or default engine - ERB.


**Inline rendering**

If block given, the template will not be searched/rendered.<br/>
Instead, it will render the string returned by the block.<br/>
This way you'll can render data from DB directly, without saving it to file system.


*=== Important ===* If custom controller given, rendering methods will use the path, engine and layout set by given controller.

**[ [contents &uarr;](https://github.com/slivu/espresso#tutorial) ]**


## Rendering Layouts


`render_layout` will render the layout of current(or given) action or an arbitrary layout file.

**Arguments**

Accepts from 0 to 3 arguments - the action/layout, the scope and the locals.<br/>
The scope is defaulted to current one and locals to an empty Hash.

If no arguments provided, it will render the layout of current action.

**Layout**

If called without arguments it will render the layout of current action.

If first argument is an existing action, the layout of given action will be rendered.<br/>
Otherwise first argument will be used as path to layout.

*Please note* that when providing layout as file, 
it wont take in count controller's route(as per `render_partial`), 
so you should provide path in full(relative to templates path).

*Please note* that action can also be provided with format.

The path is built as follow:<br/>
*path to layouts + path to layout + extension*

For extension will be used the explicitly defined extension
or the default extension of used engine.

The layout should contain the `yield` statement
that will be replaced with the string returned by given block.<br/>
If no block given, the `yield` statement will be replaced by an empty string.

**Engine**

All the same as per `render` and `render_partial`.


**Examples**

*Render the layout of current action*

```ruby
render_layout { 'some string' }
```

*Render the layout of current action within custom scope*

```ruby
render_layout Object.new do
    'some string'
end
```

*Render the layout of current action within custom scope and locals*

```ruby
render_layout Object.new, :some_var => "some val" do
    'some string'
end
```

*Render the layout of :news action*

```ruby
render_layout :news do
    'some string'
end
```

*Render the .html layout of :news action*

```ruby
render_layout 'news.html' do
    'some string'
end
```

*Render the layout of :news action with custom locals*

```ruby
render_layout :some_var => "some val" do
    'some string'
end
```

*Render an arbitrary file as layout*

```ruby
render_layout 'layouts/master' do
    'some string'
end
```

*Render an arbitrary file as layout within custom scope*

```ruby
render_layout 'layouts/master', Object.new do
    'some string'
end
```


**[ [contents &uarr;](https://github.com/slivu/espresso#tutorial) ]**



## Ad hoc Engines


`render_{engine}` and `render_{engine}_file` methods used for cases when a template or action should be "quickly" rendered
using a specific engine, without any previous class level setups.

For example, to render a Haml template of current controller, use `render_haml`.

To render 

It accepts from 0 to 3 arguments - the action/file, the scope and the locals.<br/>
The scope is defaulted to current one and locals to an empty Hash.

If no file and no block given, current action will be rendered.<br/>
If a file and a block given, the file should be a layout, i.e. should contain `yield` statement.<br/>
If block given and the file is not, the string returned by block will be used as template, a.k.a inline rendering.

If given file has no extension, it will use the method suffix.<br/>
For example, `render_haml` will add ".haml" extension to files,<br/>
`render_less` will add ".less",<br/>
`render_liquid` will add ".liquid", etc.

If both a file and a block given, the given file will be treated as a layout,
so it should contain the `yield` statement
that will be replaced with the string returned by given block.

**[ [contents &uarr;](https://github.com/slivu/espresso#tutorial) ]**


## Templates Compilation


For most web sites, most time are spent at templates rendering.<br/>
When rendering templates, most time are spent at reading and compiling.

You can skip these expensive operations by using built-in compiler.

It will simply store compiled templates in memory and on consequent requests will just render them,
avoiding filesystem calls for reading and CPU time for compiling templates.

To use compiler you should simply pass a key/value pair to locals.<br/>
The key should be an empty string and the value an unique ID or simply true.

**Example:**

```ruby
render '' => true

render_partial :some_action, '' => true

render_partial :some_action, '' => :some_action, :foo => :bar

render_file 'some/file', Object.new, '' => true

render_haml "path/to/file", '' => "path/to/file"
```

To update compiled templates call `update_compiler!`.<br/>
If called without arguments, it will update all templates.<br/>
To update only some templates, pass their unique IDs as arguments.

**Example:**

```ruby
class App < E

    def index
        @banners = render_view :banners, '' => :banners
        @ads = render_view :ads, '' => :ads
        render '' => true
    end

    before do
        if 'some condition occurred'
            # updating only @banners and @ads
            update_compiler! :banners, :ads
        end
        if 'some another condition occurred'
            # update all templates
            update_compiler!
        end
    end
end
```

**[ [contents &uarr;](https://github.com/slivu/espresso#tutorial) ]**
