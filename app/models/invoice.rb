class Invoice < ActiveRecord::Base
  extend Queries::YearMonthDay

  belongs_to :project

  def subject
    "Consulting services from #{prior_week.beginning.to_s(:mdy)} to #{invoicing_week.end.to_s(:mdy)}"
  end

  def invoicing_week
    Week.new(Time.zone.local(year, month, day))
  end

  def prior_week
    invoicing_week.previous
  end

  def timesheets
    find_projects_timesheets.map(&:timesheet).uniq
  end

  private
    def find_projects_timesheets
      ( ProjectsTimesheet.for_week_and_project(self.prior_week, self.project) +
        ProjectsTimesheet.for_week_and_project(self.invoicing_week, self.project)
      ).reject {|pt| pt.timesheet.empty? }
    end

end
