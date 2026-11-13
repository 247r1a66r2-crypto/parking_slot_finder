
import 'package:flutter/material.dart';

void main() {
  runApp(const ParkingApp());
}

// COLORS
const Color primaryBlue = Color(0xFF246BFD);
const Color darkBlue = Color(0xFF14213D);
const Color bgColor = Color(0xFFF5F7FC);

// PARKING MODEL
class ParkingLot {
  final String name;
  final String address;
  final String distance;
  final int price;
  final int available;
  final int total;
  final double rating;

  const ParkingLot({
    required this.name,
    required this.address,
    required this.distance,
    required this.price,
    required this.available,
    required this.total,
    required this.rating,
  });
}

// SAMPLE PARKING DATA
const List<ParkingLot> parkingLots = [
  ParkingLot(
    name: "City Center Parking",
    address: "Main Road, Hyderabad",
    distance: "0.5 km",
    price: 30,
    available: 12,
    total: 30,
    rating: 4.8,
  ),
  ParkingLot(
    name: "Metro Mall Parking",
    address: "Kukatpally, Hyderabad",
    distance: "1.2 km",
    price: 40,
    available: 8,
    total: 25,
    rating: 4.6,
  ),
  ParkingLot(
    name: "Smart Park Zone",
    address: "Miyapur, Hyderabad",
    distance: "2.0 km",
    price: 25,
    available: 15,
    total: 40,
    rating: 4.5,
  ),
  ParkingLot(
    name: "Airport Parking",
    address: "Shamshabad, Hyderabad",
    distance: "5.0 km",
    price: 50,
    available: 5,
    total: 20,
    rating: 4.9,
  ),
];

// BOOKING MODEL
class ParkingBooking {
  final ParkingLot lot;
  final String slot;
  final DateTime date;
  final int amount;

  ParkingBooking({
    required this.lot,
    required this.slot,
    required this.date,
    required this.amount,
  });
}

// MAIN APPLICATION
class ParkingApp extends StatefulWidget {
  const ParkingApp({super.key});

  @override
  State<ParkingApp> createState() => _ParkingAppState();
}

class _ParkingAppState extends State<ParkingApp> {
  int selectedTab = 0;
  final List<ParkingBooking> bookings = [];

  void openDetails(ParkingLot lot) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ParkingDetailsScreen(
          lot: lot,
          onBook: (booking) {
            setState(() {
              bookings.add(booking);
            });

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Parking booked successfully!"),
                backgroundColor: Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onOpen: openDetails),
      ExploreScreen(onOpen: openDetails),
      BookingScreen(
        bookings: bookings,
        onCancel: (index) {
          setState(() {
            bookings.removeAt(index);
          });
        },
      ),
      const ProfileScreen(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Parking Finder',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
        ),
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        body: SafeArea(
          child: screens[selectedTab],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedTab,
          onDestinationSelected: (index) {
            setState(() {
              selectedTab = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: "Explore",
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border),
              selectedIcon: Icon(Icons.bookmark),
              label: "Bookings",
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

// COMMON HEADER
Widget pageTitle(String title, String subtitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: darkBlue,
        ),
      ),
      const SizedBox(height: 5),
      Text(
        subtitle,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
    ],
  );
}

// HOME SCREEN
class HomeScreen extends StatelessWidget {
  final Function(ParkingLot) onOpen;

  const HomeScreen({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFE4ECFF),
                child: Icon(
                  Icons.local_parking,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "Find Your Parking",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.notifications_none,
                size: 28,
              ),
            ],
          ),

          const SizedBox(height: 25),

          // SEARCH BAR
          TextField(
            decoration: InputDecoration(
              hintText: "Search parking location...",
              prefixIcon: const Icon(
                Icons.search,
                color: primaryBlue,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 22),

          // BANNER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF246BFD),
                  Color(0xFF1746A2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Smart Parking",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Find your perfect parking spot\nquickly and easily.",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.local_parking,
                  size: 65,
                  color: Colors.white,
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          pageTitle(
            "Parking Overview",
            "Available parking statistics",
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: overviewCard(
                  "Available",
                  "40",
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: overviewCard(
                  "Occupied",
                  "25",
                  Icons.directions_car,
                  Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          pageTitle(
            "Nearby Parking",
            "Choose your preferred parking location",
          ),

          const SizedBox(height: 15),

          ...parkingLots.map(
            (lot) => ParkingCard(
              lot: lot,
              onTap: () => onOpen(lot),
            ),
          ),
        ],
      ),
    );
  }
}

// OVERVIEW CARD
Widget overviewCard(
  String title,
  String count,
  IconData icon,
  Color color,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 12),
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}

// PARKING CARD
class ParkingCard extends StatelessWidget {
  final ParkingLot lot;
  final VoidCallback onTap;

  const ParkingCard({
    super.key,
    required this.lot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EFFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_parking,
                    size: 32,
                    color: primaryBlue,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lot.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        lot.address,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 16,
                          ),
                          Text(" ${lot.rating}"),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.location_on_outlined,
                            size: 15,
                          ),
                          Text(" ${lot.distance}"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 25),
            Row(
              children: [
                Text(
                  "₹${lot.price}/hour",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: primaryBlue,
                  ),
                ),
                const Spacer(),
                Text(
                  "${lot.available}/${lot.total} slots available",
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("View Parking Slots"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// EXPLORE SCREEN
class ExploreScreen extends StatefulWidget {
  final Function(ParkingLot) onOpen;

  const ExploreScreen({super.key, required this.onOpen});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final filteredLots = parkingLots.where((lot) {
      return lot.name.toLowerCase().contains(
            searchText.toLowerCase(),
          ) ||
          lot.address.toLowerCase().contains(
            searchText.toLowerCase(),
          );
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pageTitle(
            "Explore Parking",
            "Discover available parking spaces",
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: "Search locations...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: filteredLots.isEmpty
                ? const Center(
                    child: Text("No parking locations found."),
                  )
                : ListView.builder(
                    itemCount: filteredLots.length,
                    itemBuilder: (context, index) {
                      return ParkingCard(
                        lot: filteredLots[index],
                        onTap: () => widget.onOpen(
                          filteredLots[index],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// PARKING DETAILS AND SLOT SELECTION
class ParkingDetailsScreen extends StatefulWidget {
  final ParkingLot lot;
  final Function(ParkingBooking) onBook;

  const ParkingDetailsScreen({
    super.key,
    required this.lot,
    required this.onBook,
  });

  @override
  State<ParkingDetailsScreen> createState() =>
      _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState
    extends State<ParkingDetailsScreen> {
  String selectedSlot = "A-01";

  final Set<String> occupiedSlots = {
    "A-03",
    "A-05",
    "B-02",
    "B-04",
    "C-01",
    "C-05",
  };

  final List<String> slots = [
    "A-01", "A-02", "A-03", "A-04", "A-05",
    "B-01", "B-02", "B-03", "B-04", "B-05",
    "C-01", "C-02", "C-03", "C-04", "C-05",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parking Details"),
        backgroundColor: bgColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 155,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF246BFD),
                    Color(0xFF1746A2),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(
                  Icons.local_parking,
                  size: 85,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.lot.name,
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              widget.lot.address,
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                detailInfo(
                  "Price",
                  "₹${widget.lot.price}/hr",
                  Icons.currency_rupee,
                ),
                const SizedBox(width: 12),
                detailInfo(
                  "Available",
                  "${widget.lot.available} slots",
                  Icons.local_parking,
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Select Your Parking Slot",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Choose one of the available slots below.",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // SLOT LEGEND
            Wrap(
              spacing: 15,
              runSpacing: 10,
              children: [
                legend(Colors.green, "Available"),
                legend(primaryBlue, "Selected"),
                legend(Colors.red, "Occupied"),
              ],
            ),

            const SizedBox(height: 20),

            // PARKING GRID
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: slots.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                final slot = slots[index];
                final isOccupied = occupiedSlots.contains(slot);
                final isSelected = selectedSlot == slot;

                final color = isOccupied
                    ? Colors.red
                    : isSelected
                        ? primaryBlue
                        : Colors.green;

                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: isOccupied
                      ? null
                      : () {
                          setState(() {
                            selectedSlot = slot;
                          });
                        },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      border: Border.all(
                        color: color,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car,
                          color: color,
                          size: 25,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          slot,
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // BOOKING BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  widget.onBook(
                    ParkingBooking(
                      lot: widget.lot,
                      slot: selectedSlot,
                      date: DateTime.now(),
                      amount: widget.lot.price,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Book Slot $selectedSlot",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DETAIL INFORMATION
Widget detailInfo(
  String title,
  String value,
  IconData icon,
) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: primaryBlue),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    ),
  );
}

// SLOT LEGEND
Widget legend(Color color, String title) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: 12,
        width: 12,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
      const SizedBox(width: 5),
      Text(title, style: const TextStyle(fontSize: 12)),
    ],
  );
}

// BOOKINGS SCREEN
class BookingScreen extends StatelessWidget {
  final List<ParkingBooking> bookings;
  final Function(int) onCancel;

  const BookingScreen({
    super.key,
    required this.bookings,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pageTitle(
            "My Bookings",
            "Manage your parking reservations",
          ),
          const SizedBox(height: 20),

          if (bookings.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_border,
                      size: 70,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "No Bookings Yet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your parking reservations will appear here.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];

                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.local_parking,
                                color: primaryBlue,
                                size: 30,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  booking.lot.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ],
                          ),
                          const Divider(height: 25),
                          Text("Slot: ${booking.slot}"),
                          const SizedBox(height: 8),
                          Text(
                            "Date: ${booking.date.day}/"
                            "${booking.date.month}/"
                            "${booking.date.year}",
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Amount: ₹${booking.amount}",
                            style: const TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                onCancel(index);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Booking removed",
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Cancel Booking",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// PROFILE SCREEN
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          pageTitle(
            "My Profile",
            "Manage your account",
          ),
          const SizedBox(height: 35),

          const CircleAvatar(
            radius: 48,
            backgroundColor: Color(0xFFE4ECFF),
            child: Icon(
              Icons.person,
              color: primaryBlue,
              size: 55,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Parking User",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            "user@example.com",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 35),

          profileOption(
            Icons.person_outline,
            "Personal Information",
          ),
          profileOption(
            Icons.history,
            "Parking History",
          ),
          profileOption(
            Icons.payment,
            "Payment Methods",
          ),
          profileOption(
            Icons.notifications_outlined,
            "Notifications",
          ),
          profileOption(
            Icons.help_outline,
            "Help & Support",
          ),
          profileOption(
            Icons.settings_outlined,
            "Settings",
          ),
          profileOption(
            Icons.logout,
            "Logout",
          ),
        ],
      ),
    );
  }
}

// PROFILE OPTION
Widget profileOption(
  IconData icon,
  String title,
) {
  return Card(
    color: Colors.white,
    elevation: 0,
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      leading: Icon(
        icon,
        color: primaryBlue,
      ),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
      ),
      onTap: () {},
    ),
  );
}
