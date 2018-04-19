function k_means_cluster (data_file, k, iterations )
data  = importdata(data_file);
num_iterations = str2double(iterations);
num_clusters = str2double(k);
num_columns = size(data,2); %number of columns of training_data
num_rows = size(data,1); %number of rows of training_data
training = zeros(num_rows,num_columns);
training_new = zeros(num_rows,num_columns-1);
sum_data = zeros(num_clusters,num_columns);
avg = zeros(num_clusters,num_columns);
avg_new = zeros(num_clusters,num_columns-1);
distance = zeros(num_rows,1);
cluster = zeros(num_clusters,2);
count = 0;

for i=1 : num_columns-1
    training(:,i) = data(:,i);
end
training(:,num_columns) = randi([1 num_clusters],num_rows,1);

for i = 1:num_clusters
    for j = 1:num_rows
        if(training(j,num_columns) == i)
            sum_data(i,:)= sum_data(i,:) +  training(j,:);
            count = count+1;
        end
    end
    avg(i,:) = sum_data(i,:)/count;
    count = 0;
end
sum_data = zeros(num_clusters,num_columns);

for i = 1:num_columns-1
    training_new(:,i) = training(:,i);
    avg_new(:,i) = avg(:,i);
end

for j =1:num_clusters
    for i=1:num_rows
        if(training(i,num_columns) == j )
            distance(i,1) = sqrt(sum((training_new(i,:) - avg_new(j,:)).*(training_new(i,:) - avg_new(j,:))));
        end
    end
end
fprintf('After initialization: error = %.4f \n',sum(distance));

for q=1:num_iterations
    for i=1:num_rows
        for j=1:num_clusters
            cluster(j,1) = sqrt(sum((training_new(i,:) - avg_new(j,:)).*(training_new(i,:) - avg_new(j,:))));
            cluster(j,2) = j;
        end
        sorted_val = sortrows(cluster,1);
        training(i,num_columns) = sorted_val(1,2);
    end
    for i = 1:num_clusters
        for j = 1:num_rows
            if(training(j,num_columns) == i)
                sum_data(i,:)= sum_data(i,:) +  training(j,:);
                count = count+1;
            end
        end
    avg(i,:) = sum_data(i,:)/count;
    count = 0;
    end
    sum_data = zeros(num_clusters,num_columns);
    for i = 1:num_columns-1
        training_new(:,i) = training(:,i);
        avg_new(:,i) = avg(:,i);
    end

    for j =1:num_clusters
        for i=1:num_rows
            if(training(i,num_columns) == j )
                distance(i,1) = sqrt(sum((training_new(i,:) - avg_new(j,:)).*(training_new(i,:) - avg_new(j,:))));
            end
        end
    end
    fprintf('After iteration %2d: error = %.4f \n', q, sum(distance));
end
end