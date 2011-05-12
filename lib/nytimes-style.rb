require 'date'
require 'yaml'

# Helper methods for generating text that conforms to _The New York Times Manual of Style and Usage_.
module Nytimes
  module Style

    # > "Abbreviate the names of months from August through
    # > February in news copy when they are followed by numerals: Aug. 1; Sept.
    # > 2; Oct. 3; Nov. 4; Dec. 5; Jan. 6; Feb. 7. Do not abbreviate March,
    # > April, May, June and July except as a last resort in a chart or table."
    def nytimes_date(date)
      "#{nytimes_month_and_day date}, #{date.year}"
    end
    
    def nytimes_month_and_day(date)
      "#{nytimes_month date.month} #{date.day}"
    end
    
    def nytimes_month(month)
      raise ArgumentError.new "Unknown month: #{month}" unless (1..12).include? month
      %w(Jan. Feb. March April May June July Aug. Sept. Oct. Nov. Dec.)[month - 1]
    end

    # > "The abbreviation to be used for each state, after the names of cities,
    # > towns and counties&hellip; Use no
    # > spaces between initials like N.H. Do not abbreviate Alaska, Hawaii, Idaho,
    # > Iowa, Ohio and Utah. (Do not ordinarily use the Postal Service’s
    # > two-letter abbreviations; some are hard to tell apart on quick reading.)"
    def nytimes_state_abbrev(postal_code_or_state_name)
      state = states[postal_code_or_state_name]
      raise ArgumentError.new "Unknown postal code or state name: #{postal_code_or_state_name}" unless state
      state['nytimes_abbrev']
    end
    
    private
    
    def states
      unless @states
        @states = {}
        YAML::load(File.open(File.join(File.dirname(__FILE__), 'nytimes-style/states.yml'))).each do |state|
          @states[state['postal_code']] = @states[state['name']] = state
        end
      end
      return @states
    end

  end
end