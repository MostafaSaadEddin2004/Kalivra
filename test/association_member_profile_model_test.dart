import 'package:flutter_test/flutter_test.dart';
import 'package:kalivra/model/association/association_member_profile_model.dart';

void main() {
  test('parses detailed association projects with stages and buildings', () {
    final profile = AssociationMemberProfileModel.fromJson({
      'association': {
        'is_linked_person': true,
        'is_association_member': true,
        'has_pending_association_membership_request': false,
        'is_assigned_to_projects': true,
        'is_assigned_to_units': true,
        'has_active_memberships': true,
        'person': {},
        'memberships': [],
        'projects': [
          {
            'id': 2,
            'name': 'Project 2',
            'stages': [
              {
                'id': 4,
                'stage_definition_id': 4,
                'stage_name': 'Structural frame',
                'start_date': '2026-08-01',
                'end_date': '2026-08-15',
                'completion_percentage': 50,
                'actual_order': 0,
                'is_active': false,
                'notes': null,
                'images': ['stage-4.jpg'],
                'gallery_images': ['stage-4-gallery.jpg'],
                'gallery_items': [
                  {
                    'url': 'stage-4-gallery.jpg',
                    'description': 'Stage image description',
                    'date': '2026-08-02',
                  },
                ],
                'videos': [
                  {
                    'video_url': 'stage-4.mp4',
                    'description': 'Stage video description',
                    'date': '2026-08-03',
                  },
                ],
              },
              {
                'id': 5,
                'stage_definition_id': 5,
                'stage_name': 'Finishing',
                'completion_percentage': 25,
                'images': [],
                'gallery_images': [],
              },
            ],
            'buildings': [
              {
                'id': 2,
                'project_id': 2,
                'building_number': '22',
                'name': 'Building 1',
                'description': 'Description',
                'physical_address': null,
                'latitude': null,
                'longitude': null,
                'number_of_floors': null,
                'number_of_units': 2,
                'building_plan_url': 'plan.pdf',
                'floor_plan_images': ['floor.jpg'],
                'gallery_images': ['building.jpg'],
                'gallery_items': [
                  {
                    'url': 'building.jpg',
                    'description': 'Building image description',
                    'date': '2026-08-04',
                  },
                ],
                'videos': [
                  {
                    'video_url': 'building.mp4',
                    'description': 'Building video description',
                    'date': '2026-08-05',
                  },
                ],
                'specifications': null,
                'completion_percentage': 0,
                'total_units': 2,
                'available_units': 0,
                'allocated_units': 2,
                'delivered_units': 0,
                'units': [
                  {
                    'id': 5,
                    'building_id': 2,
                    'unit_number': '5',
                    'floor': 8,
                    'unit_area': 100,
                    'unit_status': 'allocated',
                    'unit_status_label': 'Allocated',
                    'unit_plan_url': 'unit-plan.jpg',
                    'gallery_images': ['unit-gallery.jpg'],
                    'gallery_items': [
                      {
                        'url': 'unit-gallery.jpg',
                        'description': 'Unit image description',
                        'date': '2026-08-06',
                      },
                    ],
                    'videos': [
                      {
                        'video_url': 'unit.mp4',
                        'description': 'Unit video description',
                        'date': '2026-08-07',
                      },
                    ],
                  },
                ],
                'stages': [],
              },
            ],
          },
          {
            'id': 1,
            'name': 'Project 1',
            'stages': [
              {
                'id': 1,
                'stage_name': 'Planning',
                'completion_percentage': 100,
                'images': [],
                'gallery_images': [],
              },
            ],
            'buildings': [],
          },
        ],
      },
    });

    final project2 = profile.projects.firstWhere((project) => project.id == 2);
    final project1 = profile.projects.firstWhere((project) => project.id == 1);
    final building = project2.buildings.first;

    expect(profile.projects, hasLength(2));
    expect(project2.stages, hasLength(2));
    expect(project1.stages, hasLength(1));
    expect(project2.buildings, hasLength(1));
    expect(building.physicalAddress, isNull);
    expect(building.numberOfFloors, isNull);
    expect(building.units, hasLength(1));
    expect(building.units.first.floorNumber, 8);
    expect(building.units.first.area, 100);
    expect(building.units.first.status, 'allocated');
    expect(building.units.first.statusLabel, 'Allocated');
    expect(building.units.first.allImages, hasLength(2));
    expect(
      building.galleryItems.first.description,
      'Building image description',
    );
    expect(building.videoItems.first.date, '2026-08-05');
    expect(building.units.first.galleryItems.first.date, '2026-08-06');
    expect(
      building.units.first.videoItems.first.description,
      'Unit video description',
    );
    expect(building.stages, isEmpty);
    expect(project2.stages.first.allImages, hasLength(2));
    expect(
      project2.stages.first.galleryItems.last.description,
      'Stage image description',
    );
    expect(project2.stages.first.videoItems.first.url, 'stage-4.mp4');
  });
}
