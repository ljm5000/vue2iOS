//
//  ViewController.m
//  ios-demo
//
//  Created by jimmy on 2022/6/28.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#define SET_JS_CALL_OC_METHOD @"window.APPBridges.webToNative = function(message,cb){var uniqueCallbackid = 'callback__' + Date.now() + Math.floor(Math.random() * 100000);if(this.usePromise){ var that = this; return new Promise(function(resolve,reject){that.__callbackCollections__[uniqueCallbackid] = function(err,data){if(err){reject(err);return;}resolve(data);};message.callbackid = uniqueCallbackid;window.webkit.messageHandlers.webToNative.postMessage(message);})}if(cb){    this.__callbackCollections__[uniqueCallbackid] = cb;message.callbackid = uniqueCallbackid;}window.webkit.messageHandlers.webToNative.postMessage(message);}"

@interface ViewController ()<WKNavigationDelegate, WKUIDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dist/index.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];

    NSURL *readAccessToURL = [[url URLByDeletingLastPathComponent] URLByDeletingLastPathComponent];
    [self.webview loadFileURL:url allowingReadAccessToURL:readAccessToURL];
    self.webview.UIDelegate = self;
    
    WKUserScript *wk = [[WKUserScript alloc] initWithSource:SET_JS_CALL_OC_METHOD injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [self.webview.configuration.userContentController addUserScript:wk];
    
    [self.webview.configuration.userContentController  addScriptMessageHandler:self name:@"webToNative"];
    [self.webview.configuration.userContentController  addScriptMessageHandler:self name:@"getDataFormVue"];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSString *params = @"2222";
//        NSString *jsStr = [NSString stringWithFormat:@"receiveAPPData('%@')",params];
//        [self.webview evaluateJavaScript:jsStr completionHandler:^(id _Nullable response, NSError * _Nullable error) {
//            NSLog(@" response %@ ",response);
//            NSLog(@" error %@ ",error);
//        }];
//    });
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(NSString *)execCallback:(NSString *)callbackId andError:(NSString *)error andMsg:(NSString *)msg{
    return [NSString stringWithFormat:@"window.APPBridges.__callbackCollections__['%@']('%@','%@')",callbackId,msg,error];
}

-(NSString *)deleteJSCallbackInCollections:(NSString *)callbackId {
    return [NSString stringWithFormat:@"delete window.APPBridges.__callbackCollections__['%@']",callbackId];
}

-(void)sendMessageToWeb:(NSString *)js {
    [self.webview evaluateJavaScript:js completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        NSLog(@" response %@ ",response);
        NSLog(@" error %@ ",error.description);
    }];
}

-(void)nativeRequest:(NSString *)callbackId andParams:(NSString *)params{
    NSString *js = [self execCallback:callbackId andError:@"abcdefsdfasdfwe" andMsg:@"123412312"];
    [self sendMessageToWeb:js];
    [self deleteJSCallbackInCollections:callbackId];
}

#pragma mark -WKScriptMessageHandler
 
- (void)userContentController:(WKUserContentController*)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message{
    NSString *fun = message.body[@"method"];
//    if ([fun isEqualToString:@"nativeRequest"]) {
 
        NSLog(@"是什么？---%@",message.body);
        
        NSString *callbackid = message.body[@"callbackid"];
        NSString *params = message.body[@"data"];
        [self nativeRequest:callbackid andParams:params];
        
 
       //做原生操作

//    }

}

@end
