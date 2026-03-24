import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mainBrown = Color(0xFF79573C);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // Мы убрали AppBar отсюда, так как он теперь общий в HomePage
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .snapshots(), // Убрали orderBy временно для теста
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: mainBrown));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_late_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No orders yet!', style: TextStyle(color: Colors.grey, fontSize: 18)),
                ],
              ),
            );
          }

          // Сортируем вручную по времени, если поле timestamp есть
          final orders = snapshot.data!.docs.toList();
          orders.sort((a, b) {
            final aData = a.data() as Map<String, dynamic>;
            final bData = b.data() as Map<String, dynamic>;
            final aTime = aData['timestamp'] as Timestamp?;
            final bTime = bData['timestamp'] as Timestamp?;
            if (aTime == null || bTime == null) return 0;
            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final orderDoc = orders[index];
              final order = orderDoc.data() as Map<String, dynamic>;
              final List items = order['items'] ?? [];
              final status = order['status'] ?? 'Pending';
              final customerName = order['customerName'] ?? 'Anonymous';
              final address = order['address'] ?? 'No address';
              final totalPrice = order['totalPrice'] ?? 0;
              
              String timeStr = "Just now";
              if (order['timestamp'] != null) {
                final date = (order['timestamp'] as Timestamp).toDate();
                timeStr = "${date.hour}:${date.minute.toString().padLeft(2, '0')} - ${date.day}/${date.month}";
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: mainBrown.withOpacity(0.05),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order #${orderDoc.id.substring(0, 7)}",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(timeStr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            ],
                          ),
                          _buildStatusChip(status),
                        ],
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(Icons.person_outline, "Customer", customerName),
                          const SizedBox(height: 12),
                          _buildDetailRow(Icons.location_on_outlined, "Deliver to", address),
                          
                          const Divider(height: 40),
                          
                          const Text("Items Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 12),
                          ...items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: mainBrown.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text("${item['quantity']}", style: const TextStyle(fontWeight: FontWeight.bold, color: mainBrown, fontSize: 12)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(child: Text("${item['name']}", style: const TextStyle(fontSize: 15))),
                                Text("${item['price'] * item['quantity']} ₸", style: const TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )).toList(),
                          
                          const Divider(height: 40),
                          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Grand Total", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text("$totalPrice ₸", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: mainBrown)),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          if (status != 'Delivered')
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: status == 'Pending' ? mainBrown : Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                onPressed: () => _updateStatus(orderDoc.id, status),
                                child: Text(
                                  status == 'Pending' ? "START COOKING" : "MARK AS DELIVERED",
                                  style: const TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.orange;
    if (status == 'Cooking') color = Colors.blue;
    if (status == 'Delivered') color = Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 1),
      ),
    );
  }

  Future<void> _updateStatus(String orderId, String currentStatus) async {
    String nextStatus = currentStatus == 'Pending' ? 'Cooking' : 'Delivered';
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': nextStatus,
    });
  }
}
