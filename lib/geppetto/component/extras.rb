module Geppetto
  module Component
    class Extras < Base

      def process!
        if @builder.nginx
          @builder.add_named_template('manifests/nginx.pp')
          @builder.add_template("puppet/modules/site/files/name.conf", "puppet/modules/site/#{@builder.name}.conf")
          @builder.add_dependency("jfryman-nginx", nil, git: 'https://github.com/jfryman/puppet-nginx.git')
        end

        if @builder.tmux
          @builder.add_named_template('manifests/tmux.pp')
          @builder.add_named_template('files/tmux.conf')
        end

        if @builder.vim
          @builder.add_named_template('manifests/vim.pp')
        end

        if @builder.wkhtmltopdf
          @builder.add_named_template('files/xvfb_wkhtmltopdf.sh')
        end

      end

    end
  end
end
