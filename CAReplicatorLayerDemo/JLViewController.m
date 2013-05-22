//
//  JLViewController.m
//  CAReplicatorLayerDemo
//
//  Created by Jose Luis Piedrahita on 5/21/13.
//  Copyright (c) 2013 Jose Luis Piedrahita. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "JLViewController.h"

@implementation JLViewController {
	CALayer *_tile;
}

-(CAReplicatorLayer*) basicReplicatorLayer
{
	CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
	replicatorLayer.preservesDepth = YES;
	replicatorLayer.bounds = self.view.bounds;
	replicatorLayer.position = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
	replicatorLayer.instanceDelay = .2;
	return replicatorLayer;
}

- (CATransform3D)perspectiveTransform
{
    CATransform3D perspective = CATransform3DIdentity;
	perspective.m34 = 1.0 / -900;
	self.view.layer.sublayerTransform = perspective;
    return perspective;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	_tile = [CALayer layer];
	_tile.backgroundColor = [UIColor whiteColor].CGColor;
	_tile.frame = CGRectMake(10, 30, 50, 50);
	
	CAReplicatorLayer *xReplicatorLayer = [self basicReplicatorLayer];
	xReplicatorLayer.sublayerTransform = [self perspectiveTransform];
	xReplicatorLayer.instanceCount = 6;
	xReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(50, 0, 0);
	xReplicatorLayer.instanceColor = [UIColor redColor].CGColor;
	xReplicatorLayer.instanceGreenOffset = 1.0 / 6;
	[xReplicatorLayer addSublayer:_tile];
	
	CAReplicatorLayer *yReplicatorLayer = [self basicReplicatorLayer];
	yReplicatorLayer.instanceCount = 10;
	yReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, 50, 0);
	yReplicatorLayer.instanceRedOffset = -.1;
	[yReplicatorLayer addSublayer:xReplicatorLayer];

	CAReplicatorLayer *zReplicatorLayer = [self basicReplicatorLayer];
	zReplicatorLayer.instanceCount = 5;
	zReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, 0, -100);
	[zReplicatorLayer addSublayer:yReplicatorLayer];
	[self.view.layer addSublayer:zReplicatorLayer];
	
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
	anim.duration = 10;
	anim.toValue = @(M_PI * 2.0);
	anim.repeatCount = INFINITY;
	[yReplicatorLayer addAnimation:anim forKey:@"transform.rotation.x"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	CAAnimation *animation = [_tile animationForKey:@"transform.translation.z"];
	if (!animation) {
		CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.translation.z"];
		anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		anim.toValue = @60;
		anim.autoreverses = YES;
		anim.repeatCount = INFINITY;
		[_tile addAnimation:anim forKey:@"transform.translation.z"];
	}
}

@end
