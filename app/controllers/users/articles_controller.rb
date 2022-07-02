# frozen_string_literal: true

module Users
  class ArticlesController < Users::Base
    def new
      @article = current_user.articles.new
    end
    
    def create
      @article = current_user.articles.new(article_params)
      if @article.save
        #binding.pry
        flash[:info] = '投稿しました' # 4/25訂正
        # redirect_toでarticleのshowページに飛ばす
        redirect_to users_article_path(@article)
      else
        flash[:danger] = '投稿出来ませんでした。'  # 4/25訂正
        redirect_to new_users_article_path(@article)
      end
    end
    
    def show
      @article = current_user.articles.find(params[:id])
      @article.save!
    end

    def index
      @articles = current_user.articles.all
    end

    def edit
      @article = current_user.articles.find(params[:id])
    end

    def update
      @article = current_user.articles.find(params[:id])
      if @article.update(article_params)
        flash[:info] = "『#{@article.title}』を編集致しました"
        redirect_to users_article_path(@article)
      else
        render :edit
      end
    end

    def destroy
      @article = current_user.articles.find(params[:id])
      if @article.destroy
        flash[:warning] = "『#{@article.title}』を削除致しました。"
        redirect_to users_articles_path
      else
        redirect_to :index
      end
    end
    private
    
    def article_params
      params.require(:article).permit(:content, :title)
    end
  end
end
