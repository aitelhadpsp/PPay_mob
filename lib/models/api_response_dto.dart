import 'dart:math' as math;

class ApiResponse<T> {
  bool success;
  String message;
  T? data;
  List<String> errors;
  int? statusCode;
  DateTime timestamp;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors = const [],
    this.statusCode,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    try {
      // Debug logging - remove in production
      print('ApiResponse.fromJson called with type: $T');
      print('JSON structure: ${json.keys.toList()}');
      print('Data field type: ${json['data']?.runtimeType}');
      
      T? parsedData;
      
      if (fromJsonT != null && json['data'] != null) {
        final dataValue = json['data'];
        
        try {
          // Type safety check before parsing
          if (T.toString().contains('List') && dataValue is! List) {
            print('WARNING: Expected List<T> but got ${dataValue.runtimeType} for type $T');
            print('Data content preview: ${dataValue.toString().substring(0, math.min(200, dataValue.toString().length))}');
            
            // Don't parse if types don't match
            parsedData = null;
          } else if (!T.toString().contains('List') && dataValue is List) {
            print('WARNING: Expected object but got List for type $T');
            print('Data content preview: $dataValue');
            
            // Don't parse if types don't match
            parsedData = null;
          } else {
            // Types seem to match, attempt parsing
            parsedData = fromJsonT(dataValue);
          }
        } catch (e) {
          print('Error parsing data with fromJsonT: $e');
          print('Data value: $dataValue');
          parsedData = null;
        }
      }

      return ApiResponse<T>(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: parsedData,
        errors: _parseErrors(json['errors']),
        statusCode: json['statusCode'],
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : DateTime.now(),
      );
    } catch (e) {
      print('Error in ApiResponse.fromJson: $e');
      
      // Return error response instead of throwing
      return ApiResponse<T>(
        success: false,
        message: 'Failed to parse API response: ${e.toString()}',
        data: null,
        errors: [e.toString()],
        statusCode: json['statusCode'],
        timestamp: DateTime.now(),
      );
    }
  }

  Map<String, dynamic> toJson(Object? Function(T value)? toJsonT) => {
        'success': success,
        'message': message,
        'data': data != null && toJsonT != null ? toJsonT(data!) : data,
        'errors': errors,
        'statusCode': statusCode,
        'timestamp': timestamp.toIso8601String(),
      };

  // Helper method to parse errors from different formats
  static List<String> _parseErrors(dynamic errorsField) {
    if (errorsField == null) {
      return [];
    }
    
    // Handle .NET serialization format with $values
    if (errorsField is Map<String, dynamic>) {
      if (errorsField.containsKey('\$values')) {
        final values = errorsField['\$values'];
        if (values is List) {
          return values.map((e) => e.toString()).toList();
        }
      }
      
      // Handle direct map as error (shouldn't happen but fallback)
      return [];
    }
    
    // Handle direct array format
    if (errorsField is List) {
      return errorsField.map((e) => e.toString()).toList();
    }
    
    // Single error as string
    if (errorsField is String) {
      return [errorsField];
    }
    
    return [];
  }

  static ApiResponse<T> successResponse<T>(T data, {String message = "Operation successful"}) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: 200,
    );
  }

  static ApiResponse<T> errorResponse<T>(
      String message, {
        int statusCode = 400,
        List<String>? errors,
      }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      errors: errors ?? [],
    );
  }
}

class PaginatedResponse<T> {
  List<T> data;
  int currentPage;
  int pageSize;
  int totalCount;
  int totalPages;
  bool hasNextPage;
  bool hasPreviousPage;

  PaginatedResponse({
    this.data = const [],
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalCount = 0,
    this.totalPages = 0,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    try {
      print('PaginatedResponse.fromJson called for type: $T');
      print('JSON structure: ${json.keys.toList()}');
      print('Data field type: ${json['data']?.runtimeType}');
      
      final dataField = json['data'];
      List<T> parsedData = [];
      
      if (dataField is List) {
        try {
          parsedData = dataField.map(fromJsonT).toList();
        } catch (e) {
          print('Error parsing list items: $e');
          // Return empty list instead of throwing
          parsedData = [];
        }
      } else if (dataField != null) {
        print('WARNING: PaginatedResponse expected List but got ${dataField.runtimeType}');
        // Return empty list for non-list data
        parsedData = [];
      }
      
      return PaginatedResponse<T>(
        data: parsedData,
        currentPage: json['currentPage'] ?? 1,
        pageSize: json['pageSize'] ?? 10,
        totalCount: json['totalCount'] ?? 0,
        totalPages: json['totalPages'] ?? 0,
        hasNextPage: json['hasNextPage'] ?? false,
        hasPreviousPage: json['hasPreviousPage'] ?? false,
      );
    } catch (e) {
      print('Error in PaginatedResponse.fromJson: $e');
      
      // Return empty paginated response instead of throwing
      return PaginatedResponse<T>(
        data: [],
        currentPage: 1,
        pageSize: 10,
        totalCount: 0,
        totalPages: 0,
        hasNextPage: false,
        hasPreviousPage: false,
      );
    }
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) => {
        'data': data.map(toJsonT).toList(),
        'currentPage': currentPage,
        'pageSize': pageSize,
        'totalCount': totalCount,
        'totalPages': totalPages,
        'hasNextPage': hasNextPage,
        'hasPreviousPage': hasPreviousPage,
      };

  static PaginatedResponse<T> create<T>(
      List<T> data, int currentPage, int pageSize, int totalCount) {
    int totalPages = (totalCount / pageSize).ceil();
    return PaginatedResponse<T>(
      data: data,
      currentPage: currentPage,
      pageSize: pageSize,
      totalCount: totalCount,
      totalPages: totalPages,
      hasNextPage: currentPage < totalPages,
      hasPreviousPage: currentPage > 1,
    );
  }
}

class SearchRequest {
  String? searchTerm;
  int page;
  int pageSize;
  String? sortBy;
  bool sortDescending;
  Map<String, String> filters;

  SearchRequest({
    this.searchTerm,
    this.page = 1,
    this.pageSize = 10,
    this.sortBy,
    this.sortDescending = false,
    Map<String, String>? filters,
  }) : filters = filters ?? {};

  Map<String, dynamic> toJson() => {
        'searchTerm': searchTerm,
        'page': page,
        'pageSize': pageSize,
        'sortBy': sortBy,
        'sortDescending': sortDescending,
        'filters': filters,
      };
}

class ValidationError {
  String field;
  String message;

  ValidationError({this.field = '', this.message = ''});

  factory ValidationError.fromJson(Map<String, dynamic> json) =>
      ValidationError(
        field: json['field'] ?? '',
        message: json['message'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'field': field,
        'message': message,
      };
}

class ErrorResponse {
  String message;
  List<ValidationError> validationErrors;
  String? stackTrace;
  DateTime timestamp;

  ErrorResponse({
    this.message = '',
    List<ValidationError>? validationErrors,
    this.stackTrace,
    DateTime? timestamp,
  })  : validationErrors = validationErrors ?? [],
        timestamp = timestamp ?? DateTime.now();

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        message: json['message'] ?? '',
        validationErrors: (json['validationErrors'] as List<dynamic>?)
                ?.map((e) => ValidationError.fromJson(e))
                .toList() ??
            [],
        stackTrace: json['stackTrace'],
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'validationErrors': validationErrors.map((e) => e.toJson()).toList(),
        'stackTrace': stackTrace,
        'timestamp': timestamp.toIso8601String(),
      };
}