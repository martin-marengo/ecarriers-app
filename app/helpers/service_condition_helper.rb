module ServiceConditionHelper

  def service_condition_time_text service_condition
    if service_condition.from_time and service_condition.to_time
      if service_condition.from_time.hour == service_condition.to_time.hour and
          service_condition.from_time.min == service_condition.to_time.min

        "a las #{service_condition.from_time.strftime("%H:%M")} hs"
      else

        "entre las #{service_condition.from_time.strftime("%H:%M")} y las #{service_condition.to_time.strftime("%H:%M")} hs"
      end
    end
  end

end