module Geppetto
  module Component
    class Extras < Base

      def process!
        if @builder.nginx
          @builder.add_named_template('manifests/install_nginx.pp')
          @builder.add_template("puppet/modules/name/files/name.conf", "puppet/modules/#{@builder.name}/#{@builder.name}.conf")
        end

        if @builder.tmux
          @builder.add_named_template('manifests/install_tmux.pp')
          @builder.add_named_template('files/tmux.conf')
        end

        if @builder.vim
          @builder.add_named_template('manifests/install_vim.pp')
        end

        if @builder.wkhtmltopdf
          @builder.add_named_template('files/xvfb_wkhtmltopdf.sh')
        end

      end

    end
  end
end
