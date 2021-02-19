% ------------------------------------------------------------------------
%          Run Allen Atlas Browser
% ------------------------------------------------------------------------
%%
% [image_save_folder,probe_save_name_suffix,probe_lengths,processed_images_folder]=getProbeParametersAnimal('AA_190906_050');
% image_save_folder = 'Y:\giocomo\export\data\Projects\JohnKei_NPH3\Histology\Kei\npHCNd2_R\npHCNd2_R1_zenlite3';
probe_save_name_suffix = 'combined';
processed_images_folder = 'C:\Users\emily\Downloads\Histology\processed';

%% Some Defaults Paths

% directory of reference atlas files
annotation_volume_location = 'C:\Users\emily\Downloads\Histology\annotation_volume_10um_by_index.npy';
structure_tree_location = 'C:\Users\emily\OneDrive - Stanford\GitHub\GiocomoLab\allenCCF\structure_tree_safe_2017.csv';
template_volume_location = 'C:\Users\emily\Downloads\Histology\template_volume_10um.npy';

% plane to view ('coronal', 'sagittal', 'transverse')
plane = 'sagittal';


%% GET PROBE TRAJECTORY POINTS

% load the reference brain and region annotations
if ~exist('av','var') || ~exist('st','var') || ~exist('tv','var')
    disp('loading reference atlas...')
    av = readNPY(annotation_volume_location);
    st = loadStructureTree(structure_tree_location);
    tv = readNPY(template_volume_location);
end

% select the plane for the viewer
if strcmp(plane,'coronal')
    av_plot = av;
    tv_plot = tv;
elseif strcmp(plane,'sagittal')
    av_plot = permute(av,[3 2 1]);
    tv_plot = permute(tv,[3 2 1]);
elseif strcmp(plane,'transverse')
    av_plot = permute(av,[2 3 1]);
    tv_plot = permute(tv,[2 3 1]);
end

% create Atlas viewer figure
f = figure('Name','Atlas Viewer'); 

% show histology in Slice Viewer
try; figure(slice_figure_browser); title('');
catch; slice_figure_browser = figure('Name','Slice Viewer'); end
reference_size = size(tv_plot);
sliceBrowser(slice_figure_browser, processed_images_folder, f, reference_size);


% use application in Atlas Transform Viewer
% use this function if you have a processed_images_folder with appropriately processed .tif histology images
f = AtlasTransformBrowser(f, tv_plot, av_plot, st, slice_figure_browser, processed_images_folder, probe_save_name_suffix); 


% use the simpler version, which does not interface with processed slice images
% just run these two lines instead of the previous 5 lines of code
% 
% save_location = processed_images_folder;
% f = allenAtlasBrowser(tv_plot, av_plot, st, save_location, probe_save_name_suffix);


% Flip?
pause
files = dir('C:\Users\emily\Downloads\Histology\processed/*.tif');
for iF =1:numel(files)
    fp = fullfile(files(iF).folder,files(iF).name);
    im = imread(fp);
    im = flip(imrotate(im,-90),1);
    %figure;
    %imshow(im)
    imwrite(im,fp);
end