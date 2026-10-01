//
//  PostInteractions.x
//  NeoFreeBird
//

#import "Headers/T1Headers.h"

static void BHTSetPostInteractionCounts(UIViewController* controller, TFNTwitterStatus* status) {
    if (status == nil || ![controller isViewLoaded]) {
        return;
    }

    controller.navigationItem.title = [NSString stringWithFormat:@"Quotes: %lld  Retweets: %lld",
                                                                  status.quoteCount,
                                                                  status.retweetCount];
}

%hook T1PostInteractionsViewController

- (void)viewDidLoad {
    %orig;

    TFNTwitterAccount* account = [self valueForKey:@"account"];
    NSNumber* statusID = [self valueForKey:@"statusID"];
    if (account == nil || statusID == nil || account.model == nil) {
        return;
    }

    __weak T1PostInteractionsViewController* weakSelf = self;
    [account.model lookUpStatusForID:statusID.longLongValue
                     completionBlock:^(TFNTwitterStatus* status) {
                         dispatch_async(dispatch_get_main_queue(), ^{
                             BHTSetPostInteractionCounts(weakSelf, status);
                         });
                     }];
}

%end