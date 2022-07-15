function varargout = rectangles(varargin)
%RECTANGLES Plot multiple rectangles as a single patch.
%   RECTANGLES(POS) adds one or more rectangles to the current figure at 
%   the input position(s), given as an Mx4 array of M rectangle vectors.
%
%   H = RECTANGLES(___) returns the graphics object handle to the patch
%   containing the rectangles.
%
%   [___] = RECTANGLES(___,Name,Value) uses additional parameter name-value
%   pairs: Valid parameters include:
%
%       'Colormap'      Colormap, specified either as a string for one of
%                       the built-in colormaps (e.g. 'parula', 'jet',
%                       'gray'), or an Nx3 array of RGB triplets, where N
%                       is the number of unique colors. This parameter only
%                       matters if 'EdgeColor' or 'FaceColor' is set to
%                       'shuffle'.
%
%                       Default: 'parula'
%
%       'EdgeColor'     Color of rectangle edges, expressed as an RGB
%                       triplet (one color for all rectangles), an Mx3 
%                       array of RGB triplets (one color for each
%                       rectangle), a color string in short (e.g. 'k') or
%                       long (e.g. 'black') form, 'shuffle' (to randomize
%                       the colors in 'Colormap'), or 'none'.
%
%                       Default: 'k'
%
%       'FaceAlpha'     Transparency of rectangles, expressed as a numeric
%                       scalar in the range [0,1] or a vector of M alpha
%                       values, one for each rectangle.
%
%                       Default: 1
%
%       'FaceColor'     Color of rectangle faces, expressed as an RGB
%                       triplet (one color for all rectangles), an Mx3 
%                       array of RGB triplets (one color for each
%                       rectangle), a color string in short (e.g. 'k') or
%                       long (e.g. 'black') form, 'shuffle' (to randomize
%                       the colors in 'Colormap'), or 'none'.
%
%                       Default: 'none'
%
%       'LineStyle'     Line style, specified as one of the following
%                       strings: {'-','--',':','-.','none'}.
%
%                       Default: '-'
%
%       'LineWidth'     Line width, specified as a positive numeric scalar
%                       in points.
%
%                       Default: 1.5
%
%   Notes:
%   1) A rectangle vector has the form [X,Y,W,H], where X and Y specify
%   the top-left corner of the rectangle and [W,H] are the width and height
%   of the rectangle, respectively.
%
%   2) Colors expressed as RGB triplets must be in the range [0,1].
%
%   3) Multiple colors cannot be used for both edges and faces. If multiple
%   colors are specified for both, the face colors take precendence. For 
%   example, if you set 'EdgeColor' to parula(M) and 'FaceColor' to jet(M),
%   then both the edges and faces will be set according to jet(M).
%
%   See also PATCH, CIRCLES.

% Copyright 2016 Matthew R. Eicholtz

% Default parameter values
default = struct(...
    'Colormap','parula',...
    'EdgeColor','k',...
    'FaceAlpha',1,...
    'FaceColor','none',...
    'LineStyle','-',...
    'LineWidth',1.5);

% Parse inputs
[pos,params] = parseinputs(default,varargin{:});

% Setup rectangle x-y data
x = pos(:,1);
y = pos(:,2);
wid = pos(:,3);
hei = pos(:,4);

X = [x,x+wid,x+wid,x]';
X = X(:);
Y = [y,y,y+hei,y+hei]';
Y = Y(:);

v = [X,Y]; %vertices
f = reshape(1:length(X),[],size(pos,1))'; %faces

% Draw rectangles(s) as patch
holdon = ishold;
hold on;
h = patch(...
    'Faces',f,...
    'Vertices',v,...
    params{:});
if ~holdon
    hold off;
end

% Return output, if requested
varargout = {h};

end

%% Helper functions
function varargout = parseinputs(default,varargin)
    p = inputParser;
    default.FaceColor = [0.4 0.4 0.4];
    default.LineWidth = 1;
    
    
    p.addRequired('pos',@validatepos);
    p.addParameter('Colormap',default.Colormap,@validateColormap);
    p.addParameter('EdgeColor',default.EdgeColor,@validateEdgeColor);
    p.addParameter('FaceAlpha',default.FaceAlpha,@validateFaceAlpha);
    p.addParameter('FaceColor',default.FaceColor,@validateFaceColor);
    p.addParameter('LineStyle',default.LineStyle,@validateLineStyle);
    p.addParameter('LineWidth',default.LineWidth,@validateLineWidth);
    
    p.parse(varargin{:});
    
    pos = p.Results.pos;
    cmap = p.Results.Colormap;
    edgecolor = p.Results.EdgeColor;
    facealpha = p.Results.FaceAlpha;
    facecolor = p.Results.FaceColor;
    linestyle = p.Results.LineStyle;
    linewidth = p.Results.LineWidth;
    
    N = size(pos,1);
    
    if ischar(cmap)
        cmap = feval(cmap,N);
    end
    
    if strcmp(edgecolor,'shuffle')
        edgecolor = 'flat';
        ind = randsample(size(cmap,1),N,size(cmap,1)<N);
        cmap = cmap(ind,:);
        cmap = kron(cmap,ones(4,1));
    end
    if size(edgecolor,1)>1
        assert(isequal(N,size(edgecolor,1)),'Number of edge colors must be the same as the number of rectangles.');
        cmap = edgecolor;
        cmap = kron(cmap,ones(4,1));
        edgecolor = 'flat';
    end
    
    if strcmp(facecolor,'shuffle')
        facecolor = 'flat';
        ind = randsample(size(cmap,1),N,size(cmap,1)<N);
        cmap = cmap(ind,:);
        cmap = kron(cmap,ones(4,1));
    end
    if size(facecolor,1)>1
        assert(isequal(N,size(facecolor,1)),'Number of face colors must be the same as the number of rectangles.');
        cmap = facecolor;
        cmap = kron(cmap,ones(4,1));
        facecolor = 'flat';
    end
    
    if length(facealpha)>1
        assert(isequal(N,length(facealpha)),'FaceAlpha must be a scalar or an Mx1 vector of alpha values, one for each rectangle.');
        amap = facealpha(:);
        facealpha = 'flat';
    else
        amap = 1;
    end
    
    cmap = permute(cmap,[1 3 2]);
    
    params = {...
        'FaceColor',facecolor,...
        'FaceAlpha',facealpha,...
        'EdgeColor',edgecolor,...
        'LineStyle',linestyle,...
        'Linewidth',linewidth,...
        'CData',cmap,...
        'CDataMapping','direct',...
        'FaceVertexAlphaData',amap};
    
    varargout = {pos,params};
end

function tf = validateColormap(x)
    tf = (ismatrix(x) && size(x,2)==3 && all(x(:)>=0) && all(x(:)<=1)) || ... %array of RGB triplets
        ismember(x,{'parula','jet','hsv','hot','cool','spring','summer',... %colormap string
        'autumn','winter','gray','bone','copper','pink','lines','colorcube',...
        'prism','flag','white'});
end
function tf = validateEdgeColor(x)
    tf = ismatrix(x) && size(x,2)==3 && all(x(:)>=0) && all(x(:)<=1) || ... %array of RGB triplets
        ischar(x) && ~isempty(str2rgb(x)) || ... %color string
        ismember(x,{'shuffle','none'}); %other valid strings
end
function tf = validateFaceAlpha(x)
    tf = (isscalar(x) && x>=0 && x<=1) || ... %scalar in range [0,1]
        (isvector(x) && all(x(:)>=0) && all(x(:)<=1)); %vector in range [0,1], one for each rectangle;
end
function tf = validateFaceColor(x)
    tf = ismatrix(x) && size(x,2)==3 && all(x(:)>=0) && all(x(:)<=1) || ... %array of RGB triplets
        ischar(x) && ~isempty(str2rgb(x)) || ... %color string
        ismember(x,{'shuffle','none'}); %other valid strings
end
function tf = validateLineStyle(x)
    tf = ismember(x,{'-','--',':','-.','none'});
end
function validateLineWidth(x)
    validateattributes(x,{'numeric'},{'scalar','real','finite','>',0});
end
function validatepos(x)
    validateattributes(x,{'numeric'},{'size',[NaN 4],'real','finite','nonempty','nonsparse'});
    validateattributes(x(:,3:4),{'numeric'},{'>',0});
end

function rgb = str2rgb(str)
    rgb = dec2bin(rem(find(strcmpi(strsplit('k b g c r m y w black blue green cyan red magenta yellow white'),str))-1,8),3)-'0';
end

