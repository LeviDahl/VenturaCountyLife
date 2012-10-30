

#import <UIKit/UIKit.h>

@interface AccountNib : UIViewController <UIAlertViewDelegate>
@property (nonatomic, retain) IBOutlet UITextField *username;
@property (nonatomic, retain) IBOutlet UITextField *password;
@property (nonatomic, retain) IBOutlet UIButton *login;
-(IBAction)loginAction:(id)sender;
-(IBAction)logoutAction:(id)sender;
@end
