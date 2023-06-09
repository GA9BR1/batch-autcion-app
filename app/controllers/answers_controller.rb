class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :authenticate_user_with_blocked_cpf!, only: [:create]

  def new
    @doubt = Doubt.find(params[:doubt_id])
    @batch = Batch.find(params[:batch_id])
    @answer = @doubt.answers.new
  end

  def account_suspended

  end

  def create
    @answer = Answer.new(answer_params)

    if current_user.id != @answer.user_id
      respond_to do |format|
        format.turbo_stream
        format.html { render :error_page, status: :unprocessable_entity }
      end
      return
    end

    approved_by = @answer.doubt.batch.approved_by
    start_date = @answer.doubt.batch.start_date
    end_date = @answer.doubt.batch.end_date
    bids_present = @answer.doubt.batch.bids.present?
    maximum_bid_amount = @answer.doubt.batch.bids.maximum(:amount)


    if (approved_by && Date.today < end_date && Date.today >= start_date) ||
       (approved_by && Date.today >= end_date && bids_present && @answer.doubt.batch.bids.find_by(amount: maximum_bid_amount).user_id == current_user.id)
      if @answer.valid?
        @answer.save
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("error-messages-answer_#{@answer.doubt.id}", partial: "shared/error_messages_answer", locals: { resource: @answer, id: @answer.doubt.id})
          end
          format.html { redirect_to @answer.doubt.batch }
        end
        return
      else
        respond_to do |format|
          format.turbo_stream { render turbo_stream: turbo_stream.replace("error-messages-answer_#{@answer.doubt.id}", partial: "shared/error_messages_answer", locals: { resource: @answer, id: @answer.doubt.id}) }
          format.html { render :new, status: :unprocessable_entity }
        end
        return
      end
    end

    respond_to do |format|
      format.turbo_stream
      format.html { render :error_page, status: :unprocessable_entity }
    end
  end

  def answer_params
    params.require(:answer).permit(:content, :doubt_id, :user_id)
  end

  def authenticate_user_with_blocked_cpf!
    authenticate_user!

    if current_user.blocked_cpf_id.present?
      redirect_to root_path, alert: 'Sua conta está suspensa'
    end
  end
end