clear;
clc;

vehicle_parameters;
vehicle_simulation;

% Sim Parameters
t = 10;
dt = 0.01;
time = 0:dt:t;

% Initialize arrays
velocity = zeros(size(time));
possible_acceleration = zeros(size(time));
acceleration = zeros(size(time));
motor_power = zeros(size(time));
battery_power = zeros(size(time));

% Current velocity
for i = 1:length(time) - 1
    if velocity(i) == 0
        F_motor = mass * a_max;
    else
        F_motor = max_motor_power_W / velocity(i);
    end
    F_drag = 0.5 * rho * Cd * Fr_A * velocity(i)^2;
    F_rolling = Crr * mass * g;
    F_resistance = F_drag + F_rolling;
    F_total = F_motor - F_resistance;
    possible_acceleration(i) = F_total / mass;
    acceleration(i) = min(possible_acceleration(i), a_max);
    velocity(i+1) = velocity(i) + acceleration(i) * dt;
    motor_power(i) = F_total * velocity(i);
    battery_power(i) = motor_power(i) / motor_efficiency;
end
possible_acceleration(end) = possible_acceleration(end-1);
acceleration(end) = acceleration(end-1);
motor_power(end) = acceleration(end-1);
battery_power(end) = battery_power(end-1);

% Plot
% Velocity vs Time
figure;
plot(time, velocity, 'b');
xlabel('Time (s)');
ylabel('Velocity (m/s)');
title('Vehicle Velocity Over Time');
grid on;

% Acceleration vs Time
figure;
plot(time, acceleration, 'r');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
title('Acceleration');
grid on;

% Motor power vs Time
figure;
plot(time, motor_power / 1000, 'g');
xlabel('Time (s)');
ylabel('Motor Power (kW)');
title('Motor Power Over Time');
grid on;

% Battery power
figure;
plot(time, battery_power / 1000, '--');
xlabel('Time (s)');
ylabel('Battery Power (kW)');
title('Battery Power Over Time');
grid on;
