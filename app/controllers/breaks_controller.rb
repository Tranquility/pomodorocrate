class BreaksController < ApplicationController
  
  include PomodorosHelper
  include BreaksHelper
  
  before_filter :authenticate
  #before_filter :correct_user
  
  # GET /breaks
  # GET /breaks.xml
  def index
    @breaks = Break.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @breaks }
      format.json { render :json => @breaks }
    end
  end

  # GET /breaks/1
  # GET /breaks/1.xml
  def show
    @break = Break.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @break }
      format.json { render :json => @break }
    end
  end

  # GET /breaks/new
  # GET /breaks/new.xml
  def new
    @break = Break.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @break }
    end
  end

  # GET /breaks/1/edit
  def edit
    @break = Break.find(params[:id])
  end

  # POST /breaks
  # POST /breaks.xml
  def create
    
    return if break_in_progress?
    
    duration = params[:duration].nil? ? Break.duration : params[:duration]
    @break = Break.new
    @break.duration = duration
    @break.user_id = current_user.id

    respond_to do |format|
      if @break.save
        format.js   { render 'widgets/timed_break', :layout => false }
        format.html { redirect_to(activities_path, :notice => 'Break was successfully created.') }
        format.xml  { render :xml => @break, :status => :created, :location => @break }
        format.json { render :json => @break, :status => :created, :location => @break }
      else
        format.js   { render :text => 'KO' }
        format.html { render :action => "new" }
        format.xml  { render :xml => @break.errors, :status => :unprocessable_entity }
        format.json { render :json => @break.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /breaks/1
  # PUT /breaks/1.xml
  def update
    @break = Break.find(params[:id])

    respond_to do |format|
      if @break.update_attributes(params[:break])
        format.js   { 
          @break = nil
          render 'widgets/timed_break', :layout => false 
        }
        format.html { redirect_to(activities_path, :notice => 'Break was successfully updated.') }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.js   { render :text => 'KO' }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @break.errors, :status => :unprocessable_entity }
        format.json { render :json => @break.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /breaks/1
  # DELETE /breaks/1.xml
  def destroy
    @break = Break.find(params[:id])
    @break.destroy

    respond_to do |format|
      format.html { redirect_to(breaks_url) }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end
  
  # GET /breaks/current
  def current
    @break = Break.where( :completed => nil, :user_id => current_user.id ).first
    
    respond_to do |format|
      unless @break.nil?
        format.xml  { render :xml => @break, :status => :created, :location => @break }
        format.json { render :json => @break, :status => :created, :location => @break }
      else
        format.xml  { head :ok }
        format.json { head :ok }
      end
    end
  end
end
