class CommentsController < ApplicationController
  
  def index
    @comment = Comment.new
    @comment.activity_id = params[:activity]
    
    @comments = Comment.where(:activity_id => params[:activity]).order("created_at ASC")
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        format.js   {  }
        format.html { render :text => 'OK' }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        format.html { render :text => 'KO' }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id = current_user.id
      if @comment.destroy
        respond_to do |format|
          format.js {  }  
          format.html { render :text => 'OK' }
          format.xml  { head :ok }
        end
      end
    end
  end

end
