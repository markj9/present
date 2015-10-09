require "test_helper"

SUNDAY = Time.zone.local(2015, 9, 6)
NEXT_SUNDAY = SUNDAY + 1.week
PREVIOUS_SUNDAY = SUNDAY - 1.week

describe Week do
  describe "for" do
    Then { assert_equal Week.new(SUNDAY), Week.for(SUNDAY.year, SUNDAY.month, SUNDAY.day) }
  end

  describe "week starts on sunday" do
    Given(:week) { Week.new(SUNDAY) }
    Then { assert_equal SUNDAY, week.beginning }
  end

  describe "next" do
    Given(:week) { Week.for(SUNDAY.year, SUNDAY.month, SUNDAY.day) }
    Then { assert_equal Week.for(NEXT_SUNDAY.year, NEXT_SUNDAY.month, NEXT_SUNDAY.day),
                        week.next }
  end

  describe "previous" do
    Given(:week) { Week.for(SUNDAY.year, SUNDAY.month, SUNDAY.day) }
    Then { assert_equal Week.for(PREVIOUS_SUNDAY.year,
                                 PREVIOUS_SUNDAY.month,
                                 PREVIOUS_SUNDAY.day), week.previous }
  end
end
