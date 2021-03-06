module InvoicesHelper
  def grouped_options_for_clients_and_projects
    clients_with_and_including_addable_projects = Client
      .includes(:projects)
      .where(:active => true)
      .where("projects.active" => true)

    Hash[
      clients_with_and_including_addable_projects.map do |c|
        [c.name, c.projects.map {|p| [p.name, p.id] } ]
      end
    ]
  end

  def options_for_weeks
    (-16..4).map {|i| Week.now + i}.select(&:invoice_week?).map do |week|
      [display_range_for_invoice_range(week), week.ymd_dash]
    end
  end

  def display_range_for_invoice_range(week)
    "#{(week - 1).beginning.to_s(:mdy)} - #{week.end.to_s(:mdy)}"
  end
end
