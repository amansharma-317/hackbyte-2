import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hackbyte2/config/utils/const.dart';
import 'package:hackbyte2/feautures/auth/auth/presentation/screens/widgets/dashboard_article.dart';
import 'package:hackbyte2/feautures/chat/presentation/providers/matching_provider.dart';
import 'package:hackbyte2/feautures/chat/presentation/screens/my_chats.dart';
import 'package:hackbyte2/feautures/hotline/presentation/screens/hotline_screen.dart';
import 'package:hackbyte2/feautures/resources/presentation/providers/article_providers.dart';
import 'package:hackbyte2/feautures/resources/presentation/screens/article_content.dart';

import '../../../../../core/providers/user_provider.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValue<UserProfile> userProfile = ref.watch(userDataProvider);
    final userProfileFuture = ref.watch(userDataProvider);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //appbar and big-box stack
                  Container(
                    height: height*0.48,
                    child: Stack(
                      children: [
                        Container(
                          height: height*0.35*0.5,
                          decoration: BoxDecoration(
                              color: Color(0x5088AB8E),
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(25),
                                bottomLeft: Radius.circular(25),
                              )
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(backgroundImage: AssetImage("assets/images/profileicon.png"),radius: 16,),
                                  Spacer(),
                                  GestureDetector(
                                      child: Icon(Icons.notifications_none_rounded),
                                    onTap: () {
                                        FirebaseAuth.instance.signOut();
                                    }
                                  ),
                                ],
                              ),
                              SizedBox(height: 12,),
                              userProfileFuture.when(
                                data: (user) {
                                  // Print the user data to the console
                                  print("Fetched user data: $user");

                                  // Return a multiline Text widget
                                  return Column(
                                    children: [
                                      Text("Good morning,", style: AppTextStyles.font_lato.copyWith(fontSize: 16),),
                                      SizedBox(height: 8,),
                                      FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.contain,
                                        child: Text(
                                            user!.username,
                                            style: AppTextStyles.font_poppins.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                  error: (error, stackTrace) => Text("Error fetching data: $error"),
                                  loading: () => Center(child: CircularProgressIndicator()),
                              )
                              // Text("username",style: AppTextStyles.font_poppins,),
                            ],
                          ),
                        ),
                        //SizedBox(height: 16,),
                        Positioned(
                            top: height*0.25*0.50,
                            //height: 288,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 16 ),
                              width: width-32,
                              height: height*0.33,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Color(0xFF88AB8E),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Text("Support is a tap away!",style: AppTextStyles.font_poppins.copyWith(fontSize: width*0.06,color: Color(0xFFF5F5F5),fontWeight: FontWeight.bold,letterSpacing: 2),),
                                  SizedBox(height: 16,),
                                  Row(
                                    children: [
                                      Column(children: [
                                        Container(
                                          height: height*0.14,
                                          width: 120 ,
                                          child: Image.asset("assets/images/cartoon.png",fit: BoxFit.fill,),
                                        ),
                                        SizedBox(height: 16,),
                                        Text("Reach Out, Speak Up",style: AppTextStyles.font_lato.copyWith(fontSize: 14,fontWeight: FontWeight.w300,color: Color(0xffFFFFFF)),),
                                        SizedBox(height: 8,),
                                        userProfileFuture.when(
                                          data: (user) {
                                            return Consumer(
                                              builder: (context, watch, child) {
                                                final result = ref.watch(matchUserProvider(user!.assessmentResponses));
                                                return ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Color(0xFF27405A),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      fixedSize: Size(width*0.4, height*0.05),
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () async {
                                                      print('before');
                                                      ref.refresh(matchUserProvider(user.assessmentResponses));
                                                      print('result is: ' + result.toString());
                                                      result.when(
                                                        data: (result) {
                                                          print('got result');
                                                          if(result.success == false) {
                                                            Fluttertoast.showToast(msg: result.errorMessage.toString());
                                                          } else if(result.success == true) {
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MyChats()));
                                                          }

                                                        },
                                                        error: (error, stackTrace) => Fluttertoast.showToast(msg: "Error fetching data: $error"),
                                                        loading: () => Fluttertoast.showToast(msg: "loading..."),
                                                      );
                                                    },
                                                    child: Text("Chat Now",style: AppTextStyles.font_poppins.copyWith(fontSize: height*0.017,fontWeight: FontWeight.w700,color: Color(0xFFFBFBFB),letterSpacing: 1),));
                                              }
                                            );
                                          },
                                          error: (error, stackTrace) => Text("Error fetching data: $error"),
                                          loading: () => Center(child: CircularProgressIndicator()),
                                        ),

                                      ],),
                                      Spacer(),
                                      // SizedBox(width: 8,),
                                      Column(
                                        children: [
                                          Container(
                                            height: height*0.14,
                                            width: 80 ,
                                            child: Image.asset("assets/images/support.png",fit: BoxFit.fill,),
                                          ),
                                          SizedBox(height: 16,),
                                          Text("Emergency Help",style: AppTextStyles.font_lato.copyWith(fontSize: 14,fontWeight: FontWeight.w300,color: Color(0xffFFFFFF)),),
                                          SizedBox(height: 8,),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFFC60404),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                fixedSize: Size(width*0.4, height*0.05),
                                                elevation: 0,
                                              ),
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => HotlineScreen()),
                                                );
                                              }, child: Text("Instant Help",style: AppTextStyles.font_poppins.copyWith(fontSize: height*0.017,fontWeight: FontWeight.w700,color: Color(0xFFFBFBFB),letterSpacing: 1),)),
                                        ],
                                      ),
                                    ],),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    height: height*0.16,
                    margin: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Color(0x3088AB8E),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Container(
                            padding: EdgeInsets.only(top:24,bottom: 16,left: 16,right: 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("1 on 1 Sessions",style: AppTextStyles.font_poppins.copyWith(fontSize: 24,fontWeight: FontWeight.w600,color: Color(0xFF393938)),),
                                SizedBox(height: 8,),
                                Text("Let's open up to the things that",style: AppTextStyles.font_poppins.copyWith(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF393938)),),
                                SizedBox(height: 8,),
                                Text("matter the most",style: AppTextStyles.font_poppins.copyWith(fontSize: 12,fontWeight: FontWeight.w400,color: Color(0xFF393938)),),
                                SizedBox(height: 12,),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){}, child:Text("Book Now",style: AppTextStyles.font_poppins.copyWith(fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 1,color: Color(0xFF27405A)),), ),
                                    SizedBox(width: 8,),
                                    Container(
                                        height: 14,
                                        width: 14,
                                        child: Image.asset("assets/images/af3984a0-4f50-45c0-b655-7c79aff67ab9.png",fit: BoxFit.fill,)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              Container(
                                  //height: 168,
                                  padding: EdgeInsets.only(top: 32,bottom: 16,right: 16),
                                  child: Image.asset("assets/images/ca98fe7d-fe0e-46bd-a3d6-7b5c32de8b76.png",fit: BoxFit.fill,)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 24,bottom: 8,top: 8),
                    child: Text("Articles",style: AppTextStyles.font_poppins.copyWith(color: Color(0xFF000000),fontSize: 16,),),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 12),
                    height: height * 0.1,
                    width: width,
                    child: ref.watch(articlesProvider).when(
                      data: (articles) {
                        print('length of articles ' + articles.length.toString());
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ArticleContent(article: articles[index])),
                                  );
                                },
                                child: Container(
                                  width: width*0.4,
                                  child: DashboardArticleCard(title: articles[index].title,),
                                )
                            );
                          },
                        );
                      },
                      loading: () => CircularProgressIndicator(),
                      error: (error, stackTrace) => Text('Error: $error'),

                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
