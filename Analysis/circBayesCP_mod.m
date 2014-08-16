function [mean_post_muPlus1, var, pCha, pred_mu] = circBayesCP_mod(data, Hazard, conc)

%% Behrens style inference over angular location in a circular change-point task with
%  Von mises distribution centered on a mean that changes with hazard
%  [Hazard] and concentration parameter (conc)

%  data are angles from 0:359.



% Free parameters: sigma = standard deviation of wrapped gaussian
%                  H     = hazard rate of change-points

%% Generative framework:
%  0) S       -- generated based on H (bernuouli variable mean H).
%  1) Mu_t+1  -- generated based on Mu_t and S;
%                if S = 1, Mu_t+1 ~U(0, 2pi);
%                if S = 0, Mu_t+1 = Mu_t;
%  2) X_t+1   -- generated based on Mu_t+1
%                X_t+1 ~VM(Mu_t+1, sigma)

%% Inference equation:

%  p(Mu_t+1| X_{1:t}) ~ p(X_{t+1}|Mu_{t+1}) \sum_{mu_{t}} \sum_{S_{t+1}}
%                           p(mu_{t+1}|S_{t+1}, mu_{t})
%                           p(S_{t+1}|H)
%                           p(Mu_{t}| previous data)

%  Strategy:
%           do inference on 3 dimensions:
%           1) \mu_t
%           2) \mu_{t+1}
%           3) \S_{t+1}

%  First step: create fixed distributions--

%           1) p(X_{t+1}|mu_{t+1})   -- 360 X 360 matrix
%           2) p(Mu_{t+1}|Mu_{t}, S_{t+1}) -- part identity, part uniform,
%           mixture weight is equal to hazard rate.


if size(data,2)>size(data, 1)
    data=data';
end





pX_tp1_giv_mu_tp1=nan(360); % preallocate space...
possX=0:359;
for i = 1:360
    pX_tp1_giv_mu_tp1(:,i)=log(circ_vmpdf(deg2rad(possX-180),  deg2rad(possX(i)-180), conc));
end






% p(Mu_{t+1}, Mu_{t}, S_{t+1});  JOINT DISTRIBUTION...

% Dim 1: Mu_{t+1}
% Dim 2: Mu_{t}
% Dim 3: S_{t+1}


jointDist=ones(360, 360, 2);
jointDist=jointDist./sum(jointDist(:));
jointDist=log(jointDist);

% conditional distribution of mu_{t+1} given mu_{t} and S
condMuPlus1(:,:,1)= eye(360);          % S=0
condMuPlus1(:,:,2)= ones(360)./(360.^2); % S=1
condMuPlus1 = log(condMuPlus1);
% Now lets multiply by the probability of S given H:

condMuPlus1=condMuPlus1+  repmat(log(permute([1-Hazard; Hazard], [3, 2, 1])), 360, 360);


% get flat prior, just to be used on first trial.
log_prior= logsumexp(logsumexp(jointDist, 2), 3) ;





mean_post_muPlus1=nan(size(data));
var=nan(size(data));
pCha=nan(size(data));


for i = 1:length(data)
    
    % First step: renumerate based on a new trial number
    
    priorMat =repmat((permute(log_prior, [2 1])), [360, 1, 2]);
    
   
    % second step: multiply by conditional matrix
    condMat=condMuPlus1+priorMat;
    
    % third step: multiply by likelihood distribution.
    logLike=pX_tp1_giv_mu_tp1(data(i)==possX, :)';
    logLike=repmat(logLike, [1, 360, 2]);
    postMat=condMat+logLike;
    
       
    
    % store some stuff:
    post_muPlus1=logsumexp(logsumexp(postMat, 2), 3);
    post_muPlus1=post_muPlus1-logsumexp(post_muPlus1);
    
    ssTheta=   sum(sind(possX').*exp(post_muPlus1));
    scTheta=   sum(cosd(possX').*exp(post_muPlus1));
    R=(ssTheta.^2 + scTheta.^2); % resultantant
    
    mean_post_muPlus1(i)=atand(ssTheta./scTheta);
    
    if ssTheta>0&&scTheta>0;
        mean_post_muPlus1(i)=atand(ssTheta./scTheta);
    elseif scTheta<0;
        mean_post_muPlus1(i)=atand(ssTheta./scTheta)+180;
    elseif scTheta>0&&ssTheta<0;
        mean_post_muPlus1(i)=atand(ssTheta./scTheta)+360;
    end
        
        
    
    
    % Hmm... lets come back to this...
    var(i+1)= 1-R;
    
    % uh... also seems strange.
    pCh=squeeze(logsumexp(logsumexp(postMat, 1), 2));
    pCh=exp(pCh-logsumexp(pCh));
    pCha(i)=pCh(2);
    
    
    % Create prior for next trial
    log_prior= logsumexp(logsumexp(post_muPlus1, 2), 3) ;
    
end

pred_mu=[nan; mean_post_muPlus1(1:end-1)];

end














