clc
clear

addpath(genpath(pwd));

%% rgp_ign
station_name = '';
ISO_short = '';
st = '2024-01-01';
et = '2024-12-31';
target_dir = 'G:\GNSS-IR_data\RINEX\Water_level\MNIS\2024';
get_from_rgp_ign(station_name, ISO_short, st, et, target_dir)

%% sonel
station_name = 'MNIS';
ISO_short = 'AUS';
st = '2024-01-01';
et = '2024-12-31';
Rinex_version = "RINEX3";
target_dir = ['G:\GNSS-IR_data\RINEX\Water_level\',station_name,'\2024'];
get_from_sonel(station_name, ISO_short, st, et, target_dir, Rinex_version)

%% earthscope
station_name = 'AT01';
ISO_short = 'USA';
st = '2024-01-01';
et = '2024-12-31';
Rinex_version = "RINEX3";
target_dir = ['G:\GNSS-IR_data\RINEX\Water_level\',station_name,'\2024'];
api_key = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Im80WDNMM1p0QkN6MmZ5RktMVW9mWiJ9.eyJpc3MiOiJodHRwczovL2xvZ2luLmVhcnRoc2NvcGUub3JnLyIsInN1YiI6ImF1dGgwfDY0YWZjMmFlMzc5NGEyNzQyMmRlOWFlMSIsImF1ZCI6WyJodHRwczovL2FjY291bnQuZWFydGhzY29wZS5vcmciLCJodHRwczovL2VhcnRoc2NvcGUtcHJvZC51cy5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNzQ5NzI0MTQxLCJleHAiOjE3NDk3NTI5NDEsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwgb2ZmbGluZV9hY2Nlc3MiLCJhenAiOiJqTXhRYmJLUEVzeldYMGE5M0FHbEJaWjhybjkxN29jeCIsInBlcm1pc3Npb25zIjpbXX0.abg2pds0M77oTEgtO6esFjJ0KU5SB3UKNN5JG1VCmI9SYz1BjHkH1wBcy63IWxQsWJNzrGB3TLSzCy49CYEI6xGfCQAmsdcwvFL3yYQ0tZ0NCjlU7t_eW3fa1GwNiV2kDoNmL5rJHdoZhhcXGXDY1lGrtVmxxj8s9ZVn30LOBLLHpaCj4NPrvQEUC7jDJ8XDz1vQUnISiUcwevqINcHiR91uCRIBZmPlHdZJzuKx6OlMhzZ9P3w9QdZ2F0TAmsM0YgDq4V5J_MF5r4O4PA7uH_1iDZmKPLWYLMbpD3peuE9FCVT_HeWraz2aKMkVf5vHogFqilJE5Q1oPilg1cJeqw';
get_from_earthscope(station_name, ISO_short, st, et, target_dir, Rinex_version, api_key, 'p8')
%% 
station_name = 'SC02';
ISO_short = 'USA';
st = '2022-01-25';
et = '2022-02-27';
Rinex_version = "RINEX2";
target_dir = ['G:\GNSS-IR_data\RINEX\Water_level\',station_name,'\2022'];
api_key = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6Im80WDNMM1p0QkN6MmZ5RktMVW9mWiJ9.eyJpc3MiOiJodHRwczovL2xvZ2luLmVhcnRoc2NvcGUub3JnLyIsInN1YiI6ImF1dGgwfDY0YWZjMmFlMzc5NGEyNzQyMmRlOWFlMSIsImF1ZCI6WyJodHRwczovL2FjY291bnQuZWFydGhzY29wZS5vcmciLCJodHRwczovL2VhcnRoc2NvcGUtcHJvZC51cy5hdXRoMC5jb20vdXNlcmluZm8iXSwiaWF0IjoxNzQ4OTE4MTA2LCJleHAiOjE3NDg5NDY5MDYsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwgb2ZmbGluZV9hY2Nlc3MiLCJhenAiOiJqTXhRYmJLUEVzeldYMGE5M0FHbEJaWjhybjkxN29jeCIsInBlcm1pc3Npb25zIjpbXX0.TAdyzYlZoNYQjVWbF4WW3VkiCLtid82gfCv2Qq4rRVJ419eN77DVMvB5Z3vLW7PV1YKadVcxYiWnfvHRUVEaxlYw_pWQ9GnraNwjQrbpUr0ley6oco2ngf0afjc-92GPNMHNtn4z6NGIyJQeDq7JFxZEVtyf0jxRPnAK2nmC2ge22RjyYFWRXHUPfFy2R8cIL9ndepEFKbyCPJoou8g9B6Cu0LI_i8OAUNdx4DflRjw4hoT6hrjBbs0MhJ2zhMH7u4HBCkJlivK8chNDkUoL5yeoux073_NdBurPN6O4d9igelCQ0neY8ao_ZEbXSJKEbTht4J5zGLVhup2y_7amRw';
get_from_earthscope(station_name, ISO_short, st, et, target_dir, Rinex_version, api_key)