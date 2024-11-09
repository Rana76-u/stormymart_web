import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:stormymart_v2/Blocks/Home%20Bloc/home_state.dart';
import 'package:stormymart_v2/Screens/Product%20Card/product_card_widget.dart';
import 'package:stormymart_v2/utility/globalvariable.dart';

class AllProducts extends StatelessWidget {
  final HomeState homeState;
  const AllProducts({super.key, required this.homeState});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance
          .collection('/Products')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasData){
          return Expanded(
            flex: 0,
            child: ResponsiveGridList(
              horizontalGridSpacing: 5, // Horizontal space between grid items
              verticalGridSpacing: 0, // Vertical space between grid items
              horizontalGridMargin: 0, // Horizontal space around the grid
              verticalGridMargin: 0, // Vertical space around the grid
              minItemWidth: 250, // The minimum item width (can be smaller, if the layout constraints are smaller)
              minItemsPerRow: 2, // The minimum items to show in a single row. Takes precedence over minItemWidth
              maxItemsPerRow: 5, // The maximum items to show in a single row. Can be useful on large screens
              listViewBuilderOptions: ListViewBuilderOptions(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: true,
              ), // Options that are getting passed to the ListView.builder() function
              children: List.generate(
                  snapshot.data!.docs.length,
                      (index) {
                    if(snapshot.hasData){
                      DocumentSnapshot product = snapshot.data!.docs[index];
                      double discountCal = (product.get('price') / 100) * (100 - product.get('discount'));
                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).go('/product/${product.id}');
                        },
                        child: SizedBox(
                          //width: MediaQuery.of(context).size.width*0.48,
                          height: 465,
                          child: Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    //Pulls image from variation 1's 1st image
                                    productImage(product.id),

                                    //Discount %Off
                                    if(product.get('discount') != 0)...[
                                      productDiscount(product.get('discount')),
                                    ],
                                  ],
                                ),

                                //texts
                                Padding(
                                  padding: const EdgeInsets.all(13),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 30,),
                                      //Title
                                      productTitle(product.get('title')),

                                      const SizedBox(height: 10,),
                                      //price
                                      productPrice(discountCal),

                                      const SizedBox(height: 15,),

                                      productSoldAmount(product.get('sold')),

                                      const SizedBox(height: 15,),

                                      productButtons(context, product.id)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    else{
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
              ), // The list of widgets in the grid
            ),
          );
        }else{
          return const Center(
            child: Text(
                'NOTHING TO SHOW'
            ),
          );
        }
      },
    );
  }
}

class RecommendedForYouTitle extends StatelessWidget {
  const RecommendedForYouTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recommended For You',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                fontFamily: 'Urbanist'
            ),
          ),

          GestureDetector(
            onTap: () {
              keyword = null;
              GoRouter.of(context).go('/search');
            },
            child: const Text(
              'See All',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  fontFamily: 'Urbanist'
              ),
            ),
          ),
        ],
      );
  }
}
