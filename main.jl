using Serialization
using Statistics

data = deserialize(open("data_9m.mat", "r"))

function calculate_mean(column_data)
  n = length(column_data)
  sum_values = 0.0

  for i in 1:n
    sum_values += column_data[i]
  end

  mean_value = sum_values / n
  return mean_value
end

class1 = data[data[:,5] .== 1, :]
class2 = data[data[:,5] .== 2, :]
class3 = data[data[:,5] .== 3, :]

class1_mean = [calculate_mean(class1[:,1]), calculate_mean(class1[:,2]), calculate_mean(class1[:,3]), calculate_mean(class1[:,4])]

class2_mean = [calculate_mean(class2[:,1]), calculate_mean(class2[:,2]), calculate_mean(class2[:,3]), calculate_mean(class2[:,4])]

class3_mean = [calculate_mean(class3[:,1]), calculate_mean(class3[:,2]), calculate_mean(class3[:,3]), calculate_mean(class3[:,4])]

mean_class = [class1_mean class2_mean class3_mean]

# display(mean_class)

function count_matches(data, mean_class)
  counters = zeros(Int, size(data, 2)-1)
  percentages = zeros(Float64, size(data, 2)-1)
  total_rows = size(data, 1)
  # Initialize an empty matrix with 5 columns to store best data
  best_data = Matrix{Float16}(undef, 0, 5)
  # Loop through each row in the original data
  for i in 1:total_rows
      # Loop through each column in the data and mean_class
      for j in 1:size(data, 2)-1
          closest_value = Inf
          closest_index = -1
          # Loop through each column in mean_class
          for k in 1:size(mean_class, 2)
              diff = abs(data[i, j] - mean_class[j, k])
              if diff < closest_value
                  closest_value = diff
                  closest_index = k
              end
          end
          # Check if the class of the closest mean matches the original class
          if data[i, end] == closest_index
              counters[j] += 1
              # If this is the best feature so far, store the data
              if j == argmax(counters)
                  # Append the row to the best_data matrix
                  best_data = vcat(best_data, reshape(data[i, :], 1, :))
              end
          end
      end
  end
  # Calculate percentages
  for j in 1:size(data, 2)-1
      percentages[j] = (counters[j] / total_rows) * 100
  end
  return counters, percentages, best_data
end

comparison = count_matches(data, mean_class)

new_data = comparison[3]
#filter column 5 to get each class
class1_new = new_data[new_data[:,5] .== 1, :]
class2_new = new_data[new_data[:,5] .== 2, :]
class3_new = new_data[new_data[:,5] .== 3, :]

#calculate mean each feature of class1_new
class1_new_mean = [calculate_mean(class1_new[:,1]), calculate_mean(class1_new[:,2]), calculate_mean(class1_new[:,3]), calculate_mean(class1_new[:,4])]
#calculate mean each feature of class2_new
class2_new_mean = [calculate_mean(class2_new[:,1]), calculate_mean(class2_new[:,2]), calculate_mean(class2_new[:,3]), calculate_mean(class2_new[:,4])]
#calculate mean each feature of class3_new
class3_new_mean = [calculate_mean(class3_new[:,1]), calculate_mean(class3_new[:,2]), calculate_mean(class3_new[:,3]), calculate_mean(class3_new[:,4])]

#store all mean of class in matrix
mean_class_new = [class1_new_mean class2_new_mean class3_new_mean]

#from data, choose the data except new_data
data_new = data[.!in.(data, new_data), :]