class ExaminationKindsController < ApplicationController
  layout "application"
  require_role :admin

  # GET /examination_kinds
  # GET /examination_kinds.xml
  def index
    @examination_kinds = ExaminationKind.find(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @examination_kinds }
    end
  end

  # GET /examination_kinds/1
  # GET /examination_kinds/1.xml
  def show
    @examination_kind = ExaminationKind.find(params[:id])
    respond_to do |format|
      format.xml  { render :xml => @examination_kind }
    end
  end

  # GET /examination_kinds/new
  # GET /examination_kinds/new.xml
  def new
    @examination_kind = ExaminationKind.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @examination_kind }
    end
  end

  # GET /examination_kinds/1/edit
  def edit
    @examination_kind = ExaminationKind.find(params[:id])
  end

  # POST /examination_kinds
  # POST /examination_kinds.xml
  def create
    @examination_kind = ExaminationKind.new(params[:examination_kind])

    respond_to do |format|
      if @examination_kind.save
        flash[:notice] = 'ExaminationKind was successfully created.'
        format.html { redirect_to(examination_kinds_url) }
        format.xml  { render :xml => @examination_kind, :status => :created, :location => @examination_kind }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @examination_kind.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /examination_kinds/1
  # PUT /examination_kinds/1.xml
  def update
    @examination_kind = ExaminationKind.find(params[:id])

    respond_to do |format|
      if @examination_kind.update_attributes(params[:examination_kind])
        flash[:notice] = 'ExaminationKind was successfully updated.'
        format.html { redirect_to(examination_kinds_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @examination_kind.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /examination_kinds/1
  # DELETE /examination_kinds/1.xml
  def destroy
    @examination_kind = ExaminationKind.find(params[:id])
    if @examination_kind.destroy
      flash[:notice] = 'Examination kind was successfully deleted.'
    end

    respond_to do |format|
      format.html { redirect_to(examination_kinds_url) }
      format.xml  { head :ok }
    end
  end
end
