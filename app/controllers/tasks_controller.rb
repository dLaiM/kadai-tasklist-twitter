class TasksController < ApplicationController
  before_action :require_user_logged_in, only: [:show, :new, :create, :edit, :update, :destroy
  ]
  
  def index
    if logged_in?
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      @task = current_user.tasks.build
    end
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = "Task が正常に保存されました"
      redirect_to @task
    else
      flash.now[:danger] = "Task が保存されませんでした"
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    
    if @task.update(task_params)
      flash[:success] = "Task は正常に更新されました"
      redirect_to @task
    else
      flash[:danger] = "Task は更新されませんでした"
      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    
    flash[:success] = "Task は正常に削除されました"
    redirect_to tasks_url
  end
  
  def task_params
    params.require(:task).permit(:content, :status)
    
  end
end
