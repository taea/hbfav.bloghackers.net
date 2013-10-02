# Facebook extension
module Middleman
  module Facebook
    class Options < Struct.new(:app_id, :href)
    end

    class << self
      def options
        @@options ||= Options.new
      end

      def registered(app, options = {}, &block)
        @@options ||= Options.new(*options.values_at(*Options.members))
        yield @@options if block_given?
        app.send :include, Helpers
      end
      alias :included :registered
    end

    module Helpers
      def fb_header
        options = Middleman::Facebook.options
        return <<"EOF"
<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=#{options.app_id}";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>
EOF
      end

      def fb_like
        options = Middleman::Facebook.options
        return <<"EOF"
<div class="fb-like" data-href="#{options.href}" data-width="300" data-height="The pixel height of the plugin" data-colorscheme="light" data-layout="standard" data-action="like" data-show-faces="true" data-send="false"></div>
EOF
      end
    end
  end
end

::Middleman::Extensions.register(:facebook, Middleman::Facebook)
