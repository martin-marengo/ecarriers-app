class ServiceConditionForm < AbstractForm
  
  def get_service_condition
    type = @params[:type]
  
    case type
      when :before_of.to_s
        return BeforeCondition.new(
          date: @params[:date],
          from_time: @params[:from_time],
          to_time: @params[:to_time]
        )
    
      when :after_of.to_s
        return AfterCondition.new(
          date: @params[:date],
          from_time: @params[:from_time],
          to_time: @params[:to_time]
        )
    
      when :on.to_s
        return OnCondition.new(
          date: @params[:date],
          from_time: @params[:from_time],
          to_time: @params[:to_time]
        )
    
      when :between.to_s
        return BetweenCondition.new(
          from_date: @params[:from_date],
          to_date: @params[:to_date],
          from_time: @params[:from_time],
          to_time: @params[:to_time]
        )
    
      else
        return nil
    end
  end
end