//
//  City.m
//  Hero-ObjectiveC
//
//  Created by luca.li on 2017/1/22.
//  Copyright © 2017年 luca. All rights reserved.
//

#import "City.h"

@implementation City

@synthesize description = _description;

- (NSArray *)cities {
    
    City *vancouver = [[City alloc] init];
    vancouver.name = @"Vancouver";
    vancouver.image = [UIImage imageNamed:@"vancouver"];
    vancouver.shortDescription = @"City in Ontario";
    vancouver.description = @"Vancouver, a bustling west coast seaport in British Columbia, is among Canada’s densest, most ethnically diverse cities. A popular filming location, it’s surrounded by mountains, and also has thriving art, theatre and music scenes. Vancouver Art Gallery is known for its works by regional artists, while the Museum of Anthropology houses preeminent First Nations collections.";
    
    City *toronto = [[City alloc] init];
    toronto.name = @"Toronto";
    toronto.image = [UIImage imageNamed:@"toronto"];
    toronto.shortDescription = @"City in Ontario";
    toronto.description = @"Toronto, the capital of the province of Ontario, is a major Canadian city along Lake Ontario’s northwestern shore. It's a dynamic metropolis with a core of soaring skyscrapers, all dwarfed by the iconic CN Tower. Toronto also has many green spaces, from the orderly oval of Queen’s Park to 400-acre High Park and its trails, sports facilities and zoo.";
    
    City *montreal = [[City alloc] init];
    montreal.name = @"Montreal";
    montreal.image = [UIImage imageNamed:@"montreal"];
    montreal.shortDescription = @"City in Québec";
    montreal.description = @"Montréal is the largest city in Canada's Québec province. It’s set on an island in the Saint Lawrence River and named after Mt. Royal, the triple-peaked hill at its heart. Its boroughs, many of which were once independent cities, include neighbourhoods ranging from cobblestoned, French colonial Vieux-Montréal – with the Gothic Revival Notre-Dame Basilica at its centre – to bohemian Plateau.";
    
    return @[
      vancouver,
      toronto,
      montreal
      ];
}
@end
