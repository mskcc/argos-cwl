# Find Covered Intervals Refactor - Stage I

## Branch: feature/tempest_1

- Create a new cwl: findCoveredIntervals.cwl to contain the new code/scripts
with the improved method to find the intervals. Currently a clone of
gatk.FindCoveredIntervals

- Removed the scatter (split_intervals), gather (combine_intervals) logic around
findCoveredIntervals. Any scatter/gather login needed will be contained within the
script.

- Create a new source/sink `find_covered_intervals/fci_list` and added this to the
main output block [outputSource] and to the inputs of the downstream tools

