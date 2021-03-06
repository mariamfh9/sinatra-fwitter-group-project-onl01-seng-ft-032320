class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else  
      redirect '/login'
    end 
  end 

  get '/tweets/new' do  
    if logged_in?
      erb :'/tweets/create_tweet'
    else 
      redirect '/login'
    end 
  end 

  post '/tweets' do
    if logged_in?
      if params[:content] == ""
        redirect to "/tweets/new"
      else
        @tweet = current_user.tweets.build(content: params[:content])
        if @tweet.save
          redirect to "/tweets/#{@tweet.id}"
        else
          redirect to "/tweets/new"
        end
      end
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'/tweets/show_tweet'
    else 
      redirect '/login'
    end  
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/edit_tweet'
    else 
      redirect '/login'
    end 
  end 

  patch '/tweets/:id' do 
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? 
      if params[:content] == ""
        redirect "/tweets/#{@tweet.id}/edit"
      else 
        @tweet.update(content: params[:content])
        redirect "/tweets/#{@tweet.id}"
      end 
    else 
        redirect '/login'
    end 
  end 

  delete '/tweets/:id' do 
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in?
      if @tweet.user_id == @current_user.id
        @tweet.delete
        redirect to '/tweets'
      else 
        redirect to '/tweets'
      end 
    else  
      redirect '/login'
    end
  end

end