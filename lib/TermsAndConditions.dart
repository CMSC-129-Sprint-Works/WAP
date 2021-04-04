import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  final String pdfText = """
These terms and conditions set forth the general terms and conditions of your use of the "We Adopt Pets" mobile application or WAP App and any of its related products and services. By accessing and using the Mobile Application and Services, you acknowledge that you have read, understood, and agree to be bound by the terms of this Agreement. If you do not agree with the terms of this Agreement, you must not accept this Agreement and may not access and use the WAP App and Services. You acknowledge that this Agreement is a contract between you and the Operator, even though it is electronic and is not physically signed by you, and it governs your use of the Mobile Application and Services. 
\n
ACCOUNTS AND MEMBERSHIP
If you create an account in the WAP App, you are responsible for maintaining the security of your account and you are fully responsible for all activities that occur under the account and any other actions taken in connection with it. We may, but have no obligation to, monitor and review new accounts before you may sign in and start using the Services. Providing false contact information of any kind may cause the termination of your account. You must immediately notify us of any unauthorized uses of your account or any other breaches of security. We will not be liable for any acts or omissions by you, including any damages of any kind incurred because of such acts or omissions. We may suspend, disable, or delete your account (or any part thereof) if we determine that you have violated any provision of this agreement or that your conduct or content would damage our reputation and goodwill. If we delete your account for the foregoing reasons, you may not re-register for our Services. We may block your email address and Internet protocol address to prevent further registration.
\n
USER CONTENT
We do not own any data, information or content that you submit in the WAP App in the course of using the Service. You shall have sole responsibility for the accuracy, quality, integrity, legality, reliability, appropriateness, and intellectual property ownership or right to use of all submitted Content. We may monitor and review the Content in the WAP App submitted or created using our Services by you. You grant us permission to access, copy, distribute, store, transmit, reformat, display and perform the Content of your user account solely as required for the purpose of providing the Services to you. Without limiting any of those representations or warranties, we have the right, though not the obligation, to, in our own sole discretion, refuse or remove any Content that, in our reasonable opinion, violates any of our policies or is in any way harmful or objectionable. Unless specifically permitted by you, your use of the WAP App and Services does not grant us the license to use, reproduce, adapt, modify, publish or distribute the Content created by you or stored in your user account for commercial, marketing or any similar purpose.
\n
BACKUPS
We perform regular backups of the Content and will do our best to ensure completeness and accuracy of these backups. In the event of the hardware failure or data loss we will restore backups automatically to minimize the impact and downtime.
\n
PROHIBITED USES
In addition to other terms as set forth in the Agreement, you are prohibited from using the Mobile Application and Services or Content: (a) for any unlawful purpose; (b) to solicit others to perform or participate in any unlawful acts; (c) to violate any international, federal, provincial or state regulations, rules, laws, or local ordinances; (d) to infringe upon or violate our intellectual property rights or the intellectual property rights of others; (e) to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability; (f) to submit false or misleading information; (g) to upload or transmit viruses or any other type of malicious code that will or may be used in any way that will affect the functionality or operation of the Mobile Application and Services, third-party products and services, or the Internet; (h) to spam, phish, pharm, pretext, spider, crawl, or scrape; (i) for any obscene or immoral purpose; or (j) to interfere with or circumvent the security features of the Mobile Application and Services. We reserve the right to end your use of the WAP App  and Services for violating any of the prohibited uses.
\n
INTELLECTUAL PROPERTY RIGHTS
"Intellectual Property Rights" means all present and future rights conferred by statute, common law or equity in or in relation to any copyright and related rights, trademarks, designs, patents, inventions, goodwill and the right to sue for passing off, rights to inventions, rights to use, and all other intellectual property rights, in each case whether registered or unregistered and including all applications and rights to apply for and be granted, rights to claim priority from, such rights and all similar or equivalent rights or forms of protection and any other results of intellectual activity which subsist or will subsist now or in the future in any part of the world. This Agreement does not transfer to you any intellectual property owned by the Operator or third parties, and all rights, titles, and interests in and to such property will remain solely with the Operator. All trademarks, service marks, graphics and logos used in connection with the Mobile Application and Services, are trademarks or registered trademarks of the Operator or its licensors. Other trademarks, service marks, graphics and logos used in connection with the WAP App and Services may be the trademarks of other third parties. Your use of the Mobile Application and Services grants you no right or license to reproduce or otherwise use any of the Operator or third party trademarks.
\n
LIMITATION OF LIABILITY
To the fullest extent permitted by applicable law, in no event will the Operator, its affiliates, or licensors be liable to any person for any indirect, incidental, special, punitive, cover or consequential damages (including, without limitation, damages for use of content) however caused, under any theory of liability, including, without limitation, contract, tort, warranty, breach of statutory duty, negligence or otherwise, even if the liable party has been advised as to the possibility of such damages or could have foreseen such damages. The limitations and exclusions also apply if this remedy does not fully compensate you for any losses or fails of its essential purpose.
\n
CHANGES AND AMENDMENTS
We reserve the right to modify this Agreement or its terms relating to the WAP App and Services at any time, effective upon posting of an updated version of this Agreement in the WAP App. When we do, we will send you an email to notify you. Continued use of the WAP App and Services after any such changes shall constitute your consent to such changes.
\n
CONTACT US
If you would like to contact us to understand more about this Agreement or wish to contact us concerning any matter relating to it, you may send an email to aosurez@up.edu.ph.
This document was last updated on March 22, 2021
""";

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text(
        'Terms And Conditions',
        style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.normal,
            fontFamily: 'Fredoka One'),
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.teal[400],
      content: Scaffold(
        body: Center(
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: ListView.builder(
                controller: _scrollController,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Card(
                      child: ListTile(
                          title: Text(
                    pdfText,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Montserrat'),
                    textAlign: TextAlign.justify,
                  )));
                }),
          ),
        ),
      ),
    );
  }
}
