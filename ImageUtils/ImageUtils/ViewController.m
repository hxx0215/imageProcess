//
//  ViewController.m
//  ImageUtils
//
//  Created by hxx on 1/16/15.
//  Copyright (c) 2015 hxx. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)action:(id)sender {
    [self imageToGray];
//    [self getImageData:[UIImage imageNamed:@"imageForRead.png"]];
}

- (void)imageToGray{
    UIImage *image = [UIImage imageNamed:@"lena.png"];
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGSize size = image.size;
    int width = size.width * scale;
    int height = size.height * scale;
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    memset(pixels, 0, width * height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [image CGImage]);
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            uint32_t gray = 0.3 * rgbaPixel[1] + 0.59 * rgbaPixel[2] + 0.11 * rgbaPixel[3];//abgr
            rgbaPixel[1] = gray;
            rgbaPixel[2] = gray;
            rgbaPixel[3] = gray;
        }
    }
    CGImageRef outImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    UIImage *resultUIImage = [UIImage imageWithCGImage:outImage scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(outImage);
    self.imageView.image = resultUIImage;
}

- (unsigned char *)getImageData:(UIImage*)image
{
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);//rgba
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    return rawData;
}
@end
