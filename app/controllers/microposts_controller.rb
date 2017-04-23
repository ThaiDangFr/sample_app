class MicropostsController < ApplicationController
    before_filter :authenticate

    def create
        @micropost = current_user.microposts.build(params.require(:micropost).permit(:content))
        if @micropost.save
            flash[:success] = "Micropost enregistré"
            redirect_to root_path
        else
            @feed_items = []
            render 'pages/home'
        end
    end

    def destroy
    end
end
