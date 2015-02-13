require 'sendgrid-ruby'
class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  helper_method :destroy_all
  def index
    @posts = Post.all.order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(params[:post].permit(:title, :body))
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to posts_path
  end

  def destroy_all
    Post.delete_all
    redirect_to root_path
  end


  private

  def post_params
    params.require(:post).permit(:title, :body, :user_id)
  end

  def send_email(to, from, subject, text)
    client = SendGrid::Client.new do |c|
        c.api_user = 'zgleicher'
        c.api_key = 'dsig123'
    end
    mail = SendGrid::Mail.new do |m|
      m.to = to
      m.from = from
      m.subject = subject
      m.text = text
    end
    puts client.send(mail) 
  end

end
