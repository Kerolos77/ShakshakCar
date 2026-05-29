/*

class TechnicalSupportButton extends StatelessWidget {
  const TechnicalSupportButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigateTo(context, const TechnicalSupportView());
      },
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                spreadRadius: -5,
                offset: Offset(0, 0),
                blurRadius: 10,
              )
            ]),
        width: 40.r,
        height: 40.r,
        child: SvgPicture.asset(
          AppAssets.questionSvgPath,
        ),
      ),
    );
  }
}
*/
