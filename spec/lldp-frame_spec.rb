require File.join( File.dirname( __FILE__ ), "spec_helper" )
require "lldp-frame"


describe LldpFrame do
  it "should parse a minimal LLDP" do
    sample_packet = [
      0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e,  # Destination MAC
      0x00, 0x19, 0x2f, 0xa7, 0xb2, 0x8d,  # Source MAC
      0x88, 0xcc,  # Ethertype
      0x02, 0x07, 0x04, 0x00, 0x19, 0x2f, 0xa7, 0xb2, 0x8d,  # Chassis ID TLV
      0x04, 0x0d, 0x01, 0x55, 0x70, 0x6c, 0x69, 0x6e, 0x6b, 0x20, 0x74, 0x6f, 0x20, 0x53, 0x31,  # Port ID TLV
      0x06, 0x02, 0x00, 0x78,  # Time to live TLV
      0x00, 0x00,  # End of LLDPDU TLV
    ].pack( "C*" )

    lldp = LldpFrame.read( sample_packet )
  end


  it "should parse LLDP" do
    sample_packet = [
      0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e,  # Destination MAC
      0x00, 0x19, 0x2f, 0xa7, 0xb2, 0x8d,  # Source MAC
      0x88, 0xcc,  # Ethertype
      0x02, 0x07, 0x04, 0x00, 0x19, 0x2f, 0xa7, 0xb2, 0x8d,  # Chassis ID TLV
      0x04, 0x0d, 0x01, 0x55, 0x70, 0x6c, 0x69, 0x6e, 0x6b, 0x20, 0x74, 0x6f, 0x20, 0x53, 0x31,  # Port ID TLV
      0x06, 0x02, 0x00, 0x78,  # Time to live TLV
      0x08, 0x17, 0x53, 0x75, 0x6d, 0x6d, 0x69, 0x74, 0x33, 0x30, 0x30, 0x2d, 0x34, 0x38, 0x2d, 0x50, 0x6f, 0x72, 0x74, 0x20, 0x31, 0x30, 0x30, 0x31, 0x00,  # Port Description
      0x0a, 0x0d, 0x53, 0x75, 0x6d, 0x6d, 0x69, 0x74, 0x33, 0x30, 0x30, 0x2d, 0x34, 0x38, 0x00,  # System Name
      0x0c, 0x4c, 0x53, 0x75, 0x6d, 0x6d, 0x69, 0x74, 0x33, 0x30, 0x30, 0x2d, 0x34, 0x38, 0x20, 0x2d, 0x20, 0x56, 0x65, 0x72, 0x73, 0x69, 0x6f, 0x6e, 0x20, 0x37, 0x2e, 0x34, 0x65, 0x2e, 0x31, 0x20, 0x28, 0x42, 0x75, 0x69, 0x6c, 0x64, 0x20, 0x35, 0x29, 0x20, 0x62, 0x79, 0x20, 0x52, 0x65, 0x6c, 0x65, 0x61, 0x73, 0x65, 0x5f, 0x4d, 0x61, 0x73, 0x74, 0x65, 0x72, 0x20, 0x30, 0x35, 0x2f, 0x32, 0x37, 0x2f, 0x30, 0x35, 0x20, 0x30, 0x34, 0x3a, 0x35, 0x33, 0x3a, 0x31, 0x31, 0x00,  # System Description
      0x0e, 0x04, 0x00, 0x14, 0x00, 0x14, # System Capabilities
      0x10, 0x0e, 0x07, 0x06, 0x00, 0x01, 0x30, 0xf9, 0xad, 0xa0, 0x02, 0x00, 0x00, 0x03, 0xe9, 0x00,
      0xfe, 0x07, 0x00, 0x12, 0x0f, 0x02, 0x07, 0x01, 0x00,
      0x00, 0x00,  # End of LLDPDU TLV
    ].pack( "C*" )

    lldp = LldpFrame.read( sample_packet )
    lldp.optional_tlv[ 0 ][ :tlv_type ].should eq 4
    lldp.optional_tlv[ 1 ][ :tlv_type ].should eq 5
    lldp.optional_tlv[ 2 ][ :tlv_type ].should eq 6
    lldp.optional_tlv[ 3 ][ :tlv_type ].should eq 7
    lldp.optional_tlv[ 4 ][ :tlv_type ].should eq 8
    lldp.optional_tlv[ 5 ][ :tlv_type ].should eq 0
  end


  it "should create a valid LLDP packet" do
    # sample packet taken from http://www.cloudshark.org/captures/05a981251df9
    sample_packet = [
      0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e,  # Destination MAC
      0x00, 0x19, 0x2f, 0xa7, 0xb2, 0x8d,  # Source MAC
      0x88, 0xcc,  # Ethertype
      0x02, 0x07, 0x04, 0x00, 0x19, 0x2f, 0xa7, 0xb2, 0x8d,  # Chassis ID TLV
      0x04, 0x0d, 0x01, 0x55, 0x70, 0x6c, 0x69, 0x6e, 0x6b, 0x20, 0x74, 0x6f, 0x20, 0x53, 0x31,  # Port ID TLV
      0x06, 0x02, 0x00, 0x78,  # Time to live TLV
      0x00, 0x00  # End of LLDPDU TLV
    ].pack( "C*" )

    lldp_frame = LldpFrame.new
    lldp_frame.destination_mac = 0x0180c200000e
    lldp_frame.source_mac = 0x00192fa7b28d
    lldp_frame.chassis_id.subtype = 4
    lldp_frame.chassis_id = "\x00\x19\x2f\xa7\xb2\x8d"
    lldp_frame.port_id.subtype = 1
    lldp_frame.port_id = "Uplink to S1"
    lldp_frame.ttl = 120

    ( lldp_frame.to_binary_s.unpack( "H*" )[ 0 ] + "0000" ).should == sample_packet.unpack( "H*" )[ 0 ]
  end
end


### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
